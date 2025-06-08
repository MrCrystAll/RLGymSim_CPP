#pragma once
#include <RLGymSim_CPP/Framework.h>

namespace RLGSC {
	// https://github.com/AechPro/rocket-league-gym-sim/blob/main/rlgym_sim/utils/gamestates/physics_object.py
	struct RG_IMEXPORT PhysObj {
		Vec pos;
		RotMat rotMat;
		Vec vel, angVel;

		PhysObj() = default;
		PhysObj(const BallState& ballState);
		PhysObj(const CarState& carState);

		// Rotate 180 degrees around Z axis, scales everything by (-1, -1, 1)
		PhysObj Invert() const;

		// Mirror along X axis
		PhysObj MirrorX() const;
	};
}