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
file(GLOB_RECURSE FILES_SRC "src/*.cpp" "src/*.h")
add_library(RLGymSim_CPP STATIC ${FILES_SRC})
target_include_directories(RLGymSim_CPP PUBLIC "src" "${RocketSim_SOURCE_DIR}/src")

# Set C++ version to 20
set_target_properties(RLGymSim_CPP PROPERTIES LINKER_LANGUAGE CXX)
set_target_properties(RLGymSim_CPP PROPERTIES CXX_STANDARD 20)

target_link_libraries(RLGymSim_CPP PUBLIC RocketSim)