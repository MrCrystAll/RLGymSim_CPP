cmake_minimum_required (VERSION 3.21)

project("RLGymSim_CPP" VERSION 1.0.0)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include(Download)
include(CMakePackageConfigHelpers)
include(CheckIPOSupported)

set(RLGymSim_CPP_INSTALL_CMAKEDIR lib/cmake/RLGymSim_CPP)

# Optional: version file
write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/RLGymSim_CPPConfigVersion.cmake"
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY AnyNewerVersion
)

configure_package_config_file(
    "${CMAKE_SOURCE_DIR}/cmake/RLGymSim_CPPConfig.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/RLGymSim_CPPConfig.cmake"
    INSTALL_DESTINATION ${RLGymSim_CPP_INSTALL_CMAKEDIR}
)

message(STATUS "Binary DIR: ${CMAKE_BINARY_DIR}")

option(BUILD_SHARED_LIBS "Build shared libraries" ON)

set(ROCKETSIM_VERSION "2.2.1")
if(UNIX)
    set(ROCKETSIM_URL "https://github.com/MrCrystAll/RocketSim/releases/download/v${ROCKETSIM_VERSION}/RocketSim-linux.tar.gz")
    set(ROCKETSIM_ARCHIVE "RocketSim.tar.gz")
elseif(WIN32)
    set(ROCKETSIM_URL "https://github.com/MrCrystAll/RocketSim/releases/download/v${ROCKETSIM_VERSION}/RocketSim-windows.zip")
    set(ROCKETSIM_ARCHIVE "RocketSim.zip")
endif()

set(ROCKETSIM_DIR "${CMAKE_BINARY_DIR}/deps/RocketSim")

FETCH_AND_EXTRACT_FROM_SCRIPTS(
	URL ${ROCKETSIM_URL}
	EXTRACT_DIR ${ROCKETSIM_DIR}
	ARCHIVE_NAME ${ROCKETSIM_ARCHIVE}
)

list(APPEND CMAKE_PREFIX_PATH "${ROCKETSIM_DIR}")

find_package(RocketSim CONFIG REQUIRED)

# Add all headers and code files
file(GLOB_RECURSE FILES_SRC "src/*.cpp" "include/.h")
add_library(RLGymSim_CPP ${FILES_SRC})

# Apply a macro if building shared lib
if(BUILD_SHARED_LIBS)
    target_compile_definitions(RLGymSim_CPP PRIVATE -DWITHIN_RLGSC)
endif()

target_include_directories(RLGymSim_CPP
		PUBLIC
		$<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include>
		$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/generated>
		$<INSTALL_INTERFACE:include>
)

# Set C++ version to 20
set_target_properties(RLGymSim_CPP PROPERTIES LINKER_LANGUAGE CXX)
set_target_properties(RLGymSim_CPP PROPERTIES CXX_STANDARD 20)

target_link_libraries(RLGymSim_CPP PUBLIC RocketSim::RocketSim)

check_ipo_supported(RESULT result OUTPUT output)

if(result)
    message(STATUS "IPO / LTO supported")
    set_target_properties(RLGymSim_CPP PROPERTIES INTERPROCEDURAL_OPTIMIZATION TRUE)
else()
    message(STATUS "IPO / LTO not supported: ${output}")
endif()

# Output to build directory
configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/include/RLGymSim_CPP/version.h.in
    ${CMAKE_CURRENT_BINARY_DIR}/generated/RLGymSim_CPP/version.h
    @ONLY
)

install(FILES cmake/FindRLGymSim_CPP.cmake
        DESTINATION cmake)

include(InstallUtils)

install(DIRECTORY ${CMAKE_BINARY_DIR}/deps/RocketSim/include
	DESTINATION .
)

install(DIRECTORY ${CMAKE_BINARY_DIR}/deps/RocketSim/lib
	DESTINATION .
)

INSTALL_TARGET(TARGET_NAME RLGymSim_CPP INSTALL_CMAKEDIR ${RLGymSim_CPP_INSTALL_CMAKEDIR})

install(FILES
    ${CMAKE_SOURCE_DIR}/README.md
    DESTINATION .
)