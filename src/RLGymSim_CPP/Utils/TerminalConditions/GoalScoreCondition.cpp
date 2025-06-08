#include <RLGymSim_CPP/Utils/TerminalConditions/GoalScoreCondition.h>
#include <RLGymSim_CPP/Math.h>

bool RLGSC::GoalScoreCondition::IsTerminal(const GameState& currentState) {
	return Math::IsBallScored(currentState.ball.pos);
}