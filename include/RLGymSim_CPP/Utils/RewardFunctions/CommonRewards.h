#pragma once
#include <RLGymSim_CPP/Utils/RewardFunctions/RewardFunction.h>

namespace RLGSC {
	// https://github.com/AechPro/rocket-league-gym-sim/blob/main/rlgym_sim/utils/reward_functions/common_rewards/misc_rewards.py
	class RG_IMEXPORT EventReward : public RewardFunction {
	public:
		struct ValSet {
			constexpr static int VAL_AMOUNT = 11;
			float vals[VAL_AMOUNT] = {};

			float& operator[](int index);
		};
		ValSet weights;

		std::unordered_map<int, ValSet> lastRegisteredValues;

		struct WeightScales {
			float
				goal = 0,
				teamGoal = 0,
				concede = 0,
				assist = 0,

				touch = 0,
				shot = 0,
				shotPass = 0,
				save = 0,
				demo = 0,
				demoed = 0,
				boostPickup = 0;

			float& operator[](size_t index);
		};

		EventReward(WeightScales scales);

		static ValSet ExtractValues(const PlayerData& player, const GameState& state);

		virtual void Reset(const GameState& state);
		virtual float GetReward(const PlayerData& player, const GameState& state, const Action& prevAction);
	};

	// https://github.com/AechPro/rocket-league-gym-sim/blob/main/rlgym_sim/utils/reward_functions/common_rewards/misc_rewards.py
	class RG_IMEXPORT VelocityReward : public RewardFunction {
	public:
		bool isNegative;
		VelocityReward(bool isNegative = false);
		virtual float GetReward(const PlayerData& player, const GameState& state, const Action& prevAction);
	};

	// https://github.com/AechPro/rocket-league-gym-sim/blob/main/rlgym_sim/utils/reward_functions/common_rewards/misc_rewards.py
	class RG_IMEXPORT SaveBoostReward : public RewardFunction {
	public:
		float exponent;
		SaveBoostReward(float exponent = 0.5f);
		virtual float GetReward(const PlayerData& player, const GameState& state, const Action& prevAction);
	};

	// https://github.com/AechPro/rocket-league-gym-sim/blob/main/rlgym_sim/utils/reward_functions/common_rewards/ball_goal_rewards.py
	class RG_IMEXPORT VelocityBallToGoalReward : public RewardFunction {
	public:
		bool ownGoal = false;
		VelocityBallToGoalReward(bool ownGoal = false);
		virtual float GetReward(const PlayerData& player, const GameState& state, const Action& prevAction);
	};

	// https://github.com/AechPro/rocket-league-gym-sim/blob/main/rlgym_sim/utils/reward_functions/common_rewards/player_ball_rewards.py
	class RG_IMEXPORT VelocityPlayerToBallReward : public RewardFunction {
	public:
		virtual float GetReward(const PlayerData& player, const GameState& state, const Action& prevAction);
	};

	// https://github.com/AechPro/rocket-league-gym-sim/blob/main/rlgym_sim/utils/reward_functions/common_rewards/player_ball_rewards.py
	class RG_IMEXPORT FaceBallReward : public RewardFunction {
	public:
		virtual float GetReward(const PlayerData& player, const GameState& state, const Action& prevAction);
	};

	// https://github.com/AechPro/rocket-league-gym-sim/blob/main/rlgym_sim/utils/reward_functions/common_rewards/player_ball_rewards.py
	class RG_IMEXPORT TouchBallReward : public RewardFunction {
	public:
		float aerialWeight;
		TouchBallReward(float aerialWeight = 0);
		virtual float GetReward(const PlayerData& player, const GameState& state, const Action& prevAction);
	};
}