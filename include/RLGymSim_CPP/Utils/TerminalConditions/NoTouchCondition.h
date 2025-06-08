#pragma once
#include <RLGymSim_CPP/Utils/TerminalConditions/TerminalCondition.h>

namespace RLGSC {
	class RG_IMEXPORT NoTouchCondition : public TerminalCondition {
	public:

		int stepsSinceTouch = 0;
		int maxSteps;

		NoTouchCondition(int maxSteps);

		virtual void Reset(const GameState& initialState);

		virtual bool IsTerminal(const GameState& currentState);
	};
}