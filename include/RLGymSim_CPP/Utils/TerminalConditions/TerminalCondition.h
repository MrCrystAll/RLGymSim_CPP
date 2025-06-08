#pragma once
#include <RLGymSim_CPP/Utils/Gamestates/GameState.h>

namespace RLGSC {
	class RG_IMEXPORT TerminalCondition {
	public:
		virtual void Reset(const GameState& initialState);
		virtual bool IsTerminal(const GameState& currentState) = 0;
	};
}