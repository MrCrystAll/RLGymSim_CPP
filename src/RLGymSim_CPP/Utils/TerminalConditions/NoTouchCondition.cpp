#include <RLGymSim_CPP/Utils/TerminalConditions/NoTouchCondition.h>

RLGSC::NoTouchCondition::NoTouchCondition(int maxSteps) : maxSteps(maxSteps)
{
}

void RLGSC::NoTouchCondition::Reset(const GameState& initialState) {
	this->stepsSinceTouch = 0;
}

bool RLGSC::NoTouchCondition::IsTerminal(const GameState& currentState) {
	for (auto& player : currentState.players) {
		if (player.ballTouchedStep) {
			stepsSinceTouch = 0;
			return false;
		}
	}

	stepsSinceTouch++;
	return stepsSinceTouch >= maxSteps;
}