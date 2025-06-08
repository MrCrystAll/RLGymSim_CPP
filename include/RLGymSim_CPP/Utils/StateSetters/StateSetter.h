#pragma once
#include <RLGymSim_CPP/Utils/Gamestates/GameState.h>

namespace RLGSC {
	class RG_IMEXPORT StateSetter {
	public:

		// NOTE: Applies reset state to arena
		virtual GameState ResetState(Arena* arena) = 0;
	};
}