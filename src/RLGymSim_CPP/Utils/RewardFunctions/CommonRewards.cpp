#pragma once	
#include <RLGymSim_CPP/Utils/RewardFunctions/CommonRewards.h>

float& RLGSC::EventReward::ValSet::operator[](int index) {
	return vals[index];
}

float& RLGSC::EventReward::WeightScales::operator[](size_t index)
{
	// Make sure members line up
	static_assert(
		offsetof(WeightScales, boostPickup) - offsetof(WeightScales, goal) ==
		sizeof(float) * (ValSet::VAL_AMOUNT - 1)
		);
	return (&goal)[index];
}

RLGSC::EventReward::EventReward(WeightScales weightScales) {
	for (int i = 0; i < ValSet::VAL_AMOUNT; i++)
		weights[i] = weightScales[i];
}

RLGSC::EventReward::ValSet RLGSC::EventReward::ExtractValues(const PlayerData& player, const GameState& state) {
	ValSet result = {};

	int teamGoals = state.scoreLine[(int)player.team],
		opponentGoals = state.scoreLine[1 - (int)player.team];

	float newVals[] = {
		(float)player.matchGoals, (float)teamGoals, (float)opponentGoals, (float)player.matchAssists,
		(float)player.ballTouchedStep, (float)player.matchShots, (float)player.matchShotPasses, (float)player.matchSaves, 
		(float)player.matchDemos, (float)player.carState.isDemoed, (float)player.boostFraction
	};

	static_assert(sizeof(newVals) / sizeof(float) == ValSet::VAL_AMOUNT);

	memcpy(result.vals, newVals, sizeof(newVals));
	return result;
}

void RLGSC::EventReward::Reset(const GameState& state) {
	lastRegisteredValues = {};
	for (auto& player : state.players)
		lastRegisteredValues[player.carId] = ExtractValues(player, state);
}

float RLGSC::EventReward::GetReward(const PlayerData& player, const GameState& state, const Action& prevAction) {
	auto& oldValues = lastRegisteredValues[player.carId];
	auto newValues = ExtractValues(player, state);

	float reward = 0;
	for (int i = 0; i < ValSet::VAL_AMOUNT; i++)
		reward += RS_MAX(newValues[i] - oldValues[i], 0) * weights[i];

	oldValues = newValues;
	return reward;
}

RLGSC::VelocityReward::VelocityReward(bool isNegative) : isNegative(isNegative) {

}

float RLGSC::VelocityReward::GetReward(const PlayerData& player, const GameState& state, const Action& prevAction)
{
	return player.phys.vel.Length() / CommonValues::CAR_MAX_SPEED * (1 - 2 * isNegative);
}

RLGSC::SaveBoostReward::SaveBoostReward(float exponent) : exponent(exponent) {};

float RLGSC::SaveBoostReward::GetReward(const PlayerData& player, const GameState& state, const Action& prevAction)
{
	return RS_CLAMP(powf(player.boostFraction, exponent), 0, 1);
}

RLGSC::VelocityBallToGoalReward::VelocityBallToGoalReward(bool ownGoal) : ownGoal(ownGoal) {};

float RLGSC::VelocityBallToGoalReward::GetReward(const PlayerData& player, const GameState& state, const Action& prevAction)
{
	bool targetOrangeGoal = player.team == Team::BLUE;
	if (ownGoal)
		targetOrangeGoal = !targetOrangeGoal;

	Vec targetPos = targetOrangeGoal ? CommonValues::ORANGE_GOAL_BACK : CommonValues::BLUE_GOAL_BACK;

	Vec ballDirToGoal = (targetPos - state.ball.pos).Normalized();
	return ballDirToGoal.Dot(state.ball.vel / CommonValues::BALL_MAX_SPEED);
}

float RLGSC::VelocityPlayerToBallReward::GetReward(const PlayerData& player, const GameState& state, const Action& prevAction)
{
	Vec dirToBall = (state.ball.pos - player.phys.pos).Normalized();
	Vec normVel = player.phys.vel / CommonValues::CAR_MAX_SPEED;
	return dirToBall.Dot(normVel);
}

float RLGSC::FaceBallReward::GetReward(const PlayerData& player, const GameState& state, const Action& prevAction)
{
	Vec dirToBall = (state.ball.pos - player.phys.pos).Normalized();
	return player.carState.rotMat.forward.Dot(dirToBall);
}

RLGSC::TouchBallReward::TouchBallReward(float aerialWeight) : aerialWeight(aerialWeight) {};

float RLGSC::TouchBallReward::GetReward(const PlayerData& player, const GameState& state, const Action& prevAction)
{
	using namespace CommonValues;

	if (player.ballTouchedStep) {
		return powf((state.ball.pos.z + BALL_RADIUS) / (BALL_RADIUS * 2), aerialWeight);
	}
	else {
		return 0;
	}
}