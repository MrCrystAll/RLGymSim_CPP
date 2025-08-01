#pragma once
#include <RLGymSim_CPP/Framework.h>

namespace RLGSC {
	// https://github.com/AechPro/rocket-league-gym-sim/blob/main/rlgym_sim/utils/common_values.py
	namespace CommonValues {
		// Could just use RocketSim's RLConst but I'll just copy to stay faithful

		constexpr float
			SIDE_WALL_X = 4096,
			BACK_WALL_Y = 5120,
			CEILING_Z = 2044,
			BACK_NET_Y = 6000,

			GOAL_HEIGHT = 642.775,
			GRAVITY_Z = -650.0,
			BOOST_CONSUMED_PER_SECOND = 100.0 / 3.0;

		constexpr Vec
			ORANGE_GOAL_CENTER = Vec( 0, BACK_WALL_Y, GOAL_HEIGHT / 2 ),
			BLUE_GOAL_CENTER = Vec( 0, -BACK_WALL_Y, GOAL_HEIGHT / 2 ),

			// Often more useful than center
			ORANGE_GOAL_BACK = Vec( 0, BACK_NET_Y, GOAL_HEIGHT / 2 ),
			BLUE_GOAL_BACK = Vec( 0, -BACK_NET_Y, GOAL_HEIGHT / 2);

		constexpr float
			BALL_RADIUS = 92.75, // :nerd::point_up: "erm it is actually 91.25"

			BALL_MAX_SPEED = 6000,
			CAR_MAX_SPEED = 2300,
			SUPERSONIC_THRESHOLD = 2200,
			CAR_MAX_ANG_VEL = 5.5,

			BLUE_TEAM = 0,
			ORANGE_TEAM = 1,
			NUM_ACTIONS = 8;

		constexpr int BOOST_LOCATIONS_AMOUNT = 34;
		constexpr Vec BOOST_LOCATIONS[BOOST_LOCATIONS_AMOUNT] = {
				{0.f, -4240.0, 70.0},
				{-1792.0, -4184.0, 70.0},
				{1792.0, -4184.0, 70.0},
				{-3072.0, -4096.0, 73.0},
				{3072.0, -4096.0, 73.0},
				{-940.0, -3308.0, 70.0},
				{940.0, -3308.0, 70.0},
				{0.0, -2816.0, 70.0},
				{-3584.0, -2484.0, 70.0},
				{3584.0, -2484.0, 70.0},
				{-1788.0, -2300.0, 70.0},
				{1788.0, -2300.0, 70.0},
				{-2048.0, -1036.0, 70.0},
				{0.0, -1024.0, 70.0},
				{2048.0, -1036.0, 70.0},
				{-3584.0, 0.0, 73.0},
				{-1024.0, 0.0, 70.0},
				{1024.0, 0.0, 70.0},
				{3584.0, 0.0, 73.0},
				{-2048.0, 1036.0, 70.0},
				{0.0, 1024.0, 70.0},
				{2048.0, 1036.0, 70.0},
				{-1788.0, 2300.0, 70.0},
				{1788.0, 2300.0, 70.0},
				{-3584.0, 2484.0, 70.0},
				{3584.0, 2484.0, 70.0},
				{0.0, 2816.0, 70.0},
				{-940.0, 3310.0, 70.0},
				{940.0, 3308.0, 70.0},
				{-3072.0, 4096.0, 73.0},
				{3072.0, 4096.0, 73.0},
				{-1792.0, 4184.0, 70.0},
				{1792.0, 4184.0, 70.0},
				{0.0, 4240.0, 70.0}
		};
	}
}