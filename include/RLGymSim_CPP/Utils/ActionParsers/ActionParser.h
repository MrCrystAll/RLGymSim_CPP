#pragma once
#include <RLGymSim_CPP/Utils/Gamestates/GameState.h>
#include <RLGymSim_CPP/Utils/BasicTypes/Action.h>
#include <RLGymSim_CPP/Utils/BasicTypes/Lists.h>

// https://github.com/AechPro/rocket-league-gym-sim/blob/main/rlgym_sim/utils/obs_builders/obs_builder.py
namespace RLGSC {
	// TODO: Only designed for discrete actions currently 
	class RG_IMEXPORT ActionParser {
	public:
		typedef IList Input;

		virtual ActionSet ParseActions(const Input& actionsData, const GameState& gameState) = 0;
		virtual int GetActionAmount() = 0;
	};
}