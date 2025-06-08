cmake_minimum_required (VERSION 3.8)

project("RLGymSim_CPP" VERSION 1.0.0)

include(FetchContent)

FetchContent_Declare(
	RocketSim
	GIT_REPOSITORY https://github.com/ZealanL/RocketSim
	GIT_TAG v2.2
)
FetchContent_MakeAvailable(RocketSim)

# Add all headers and code files
file(GLOB_RECURSE FILES_SRC "src/*.cpp")
add_library(RLGymSim_CPP STATIC ${FILES_SRC})
add_library(RLGymSim_CPP_SHARED SHARED ${FILES_SRC})
target_compile_definitions(RLGymSim_CPP_SHARED PRIVATE -DWITHIN_RLGSC)
target_include_directories(RLGymSim_CPP PUBLIC "include" "${RocketSim_SOURCE_DIR}/src")
target_include_directories(RLGymSim_CPP_SHARED PUBLIC "include" "${RocketSim_SOURCE_DIR}/src")

# Set C++ version to 20
set_target_properties(RLGymSim_CPP PROPERTIES LINKER_LANGUAGE CXX)
set_target_properties(RLGymSim_CPP PROPERTIES CXX_STANDARD 20)

# Set C++ version to 20
set_target_properties(RLGymSim_CPP_SHARED PROPERTIES LINKER_LANGUAGE CXX)
set_target_properties(RLGymSim_CPP_SHARED PROPERTIES CXX_STANDARD 20)

target_link_libraries(RLGymSim_CPP PUBLIC RocketSim)
target_link_libraries(RLGymSim_CPP_SHARED PUBLIC RocketSim)