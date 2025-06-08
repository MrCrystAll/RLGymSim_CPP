#pragma once
#include <RLGymSim_CPP/Utils/Gamestates/GameState.h>
#include <RLGymSim_CPP/Utils/BasicTypes/Action.h>
#include <RLGymSim_CPP/Utils/BasicTypes/Lists.h>

// https://github.com/AechPro/rocket-league-gym-sim/blob/main/rlgym_sim/utils/obs_builders/obs_builder.py
namespace RLGSC {
	class RG_IMEXPORT OBSBuilder {
	public:
		virtual void Reset(const GameState& initialState) {}

		virtual void PreStep(const GameState& state) {}

		// NOTE: May be called once during environment initialization to determine policy neuron size
		virtual FList BuildOBS(const PlayerData& player, const GameState& state, const Action& prevAction) = 0;
	};
}