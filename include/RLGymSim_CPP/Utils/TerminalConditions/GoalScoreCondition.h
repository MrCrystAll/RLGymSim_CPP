#pragma once
#include <RLGymSim_CPP/Utils/TerminalConditions/TerminalCondition.h>

namespace RLGSC {
	class RG_IMEXPORT GoalScoreCondition : public TerminalCondition {
	public:

		virtual bool IsTerminal(const GameState& currentState);
	};
}