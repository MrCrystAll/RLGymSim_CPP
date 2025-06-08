#pragma once
#include <RLGymSim_CPP/Utils/StateSetters/StateSetter.h>

namespace RLGSC {
	class RG_IMEXPORT KickoffState : public StateSetter {
	public:
		virtual GameState ResetState(Arena* arena) {
			arena->ResetToRandomKickoff();
			return GameState(arena);
		}
	};
}