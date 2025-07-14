#include <RLGymSim_CPP/Utils/StateSetters/KickoffState.h>

RLGSC::GameState RLGSC::KickoffState::ResetState(RocketSim::Arena* arena) {
	arena->ResetToRandomKickoff();
	return RLGSC::GameState(arena);
}
