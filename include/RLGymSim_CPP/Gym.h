#pragma once
#include <RLGymSim_CPP/Envs/Match.h>
#include <RocketSim/Sim/GameEventTracker/GameEventTracker.h>

namespace RLGSC {
	class RG_IMEXPORT Gym {
	public:
		Arena* arena;
		GameEventTracker eventTracker;
		Match* match;
		int tickSkip;
		GameState prevState;
		std::vector<uint32_t> carIds;

		int totalTicks = 0;
		int totalSteps = 0;

		Gym(Match* match, int tickSkip, CarConfig carConfig = CAR_CONFIG_OCTANE, GameMode gameMode = GameMode::SOCCAR, MutatorConfig mutatorConfig = MutatorConfig(GameMode::SOCCAR));

		RG_NO_COPY(Gym);

		virtual FList2 Reset();

		struct StepResult {
			FList2 obs;
			FList reward;
			bool done;
			GameState state;
		};
		virtual StepResult Step(const ActionParser::Input& actionsData);

		virtual ~Gym() {
			delete arena;
		}
	};
}