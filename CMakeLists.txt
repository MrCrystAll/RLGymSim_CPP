cmake_minimum_required (VERSION 3.31)

project("RLGymSim_CPP" VERSION 1.0.9 LANGUAGES CXX)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include(FetchFromGH)
include(CMakePackageConfigHelpers)
include(CheckIPOSupported)
include(GNUInstallDirs)

option(PACKAGE_ROCKETSIM "Package rocketsim within the installed bins" ON)

option(BUILD_SHARED_LIBS "Build shared libraries" ON)

DOWNLOAD_GITHUB_RELEASE(
    NAME RocketSim
    REPO MrCrystAll/RocketSim
    TAG v2.2.7
)

find_package(RocketSim REQUIRED)

# Add all headers and code files
file(GLOB_RECURSE FILES_SRC "src/*.cpp" "include/.h")
add_library(${PROJECT_NAME} ${FILES_SRC})

# Apply a macro if building shared lib
if(BUILD_SHARED_LIBS)
    target_compile_definitions(${PROJECT_NAME} PRIVATE -DWITHIN_RLGSC)
endif()

target_include_directories(${PROJECT_NAME}
		PUBLIC
		$<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include>
		$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/generated>
		$<INSTALL_INTERFACE:include>
)

# Set C++ version to 20
set_target_properties(${PROJECT_NAME} PROPERTIES LINKER_LANGUAGE CXX)
set_target_properties(${PROJECT_NAME} PROPERTIES CXX_STANDARD 20)

target_link_libraries(${PROJECT_NAME} PUBLIC RocketSim::RocketSim)

check_ipo_supported(RESULT result OUTPUT output)

if(result)
    message(STATUS "IPO / LTO supported")
    set_target_properties(${PROJECT_NAME} PROPERTIES INTERPROCEDURAL_OPTIMIZATION TRUE)
else()
    message(STATUS "IPO / LTO not supported: ${output}")
endif()

# Define path variables
set(${PROJECT_NAME}_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/include")
set(${PROJECT_NAME}_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src")
set(${PROJECT_NAME}_CMAKE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# For installed package
set(${PROJECT_NAME}_INSTALL_INCLUDE_DIR "${CMAKE_INSTALL_INCLUDEDIR}")
set(${PROJECT_NAME}_INSTALL_LIB_DIR "${CMAKE_INSTALL_LIBDIR}")
set(${PROJECT_NAME}_INSTALL_CMAKE_DIR "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")
set(${PROJECT_NAME}_INSTALL_BIN_DIR "${CMAKE_INSTALL_BINDIR}")

# Optional: version file
write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY AnyNewerVersion
)

configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/${PROJECT_NAME}Config.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
    INSTALL_DESTINATION ${${PROJECT_NAME}_INSTALL_CMAKE_DIR}
)

install(TARGETS ${PROJECT_NAME}
		EXPORT ${PROJECT_NAME}Targets
		RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
		LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
		ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
		INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
	)

# Install targets file
install(EXPORT ${PROJECT_NAME}Targets
    FILE ${PROJECT_NAME}Targets.cmake
    NAMESPACE ${PROJECT_NAME}::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

# Output to build directory
configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/include/${PROJECT_NAME}/version.h.in
    ${CMAKE_CURRENT_BINARY_DIR}/generated/${PROJECT_NAME}/version.h
    @ONLY
)

# Install headers
install(DIRECTORY ${${PROJECT_NAME}_INCLUDE_DIR}/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    FILES_MATCHING PATTERN "*.h"
)

# Configure package config file
configure_package_config_file(
    ${${PROJECT_NAME}_CMAKE_DIR}/${PROJECT_NAME}Config.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
    PATH_VARS CMAKE_INSTALL_INCLUDEDIR CMAKE_INSTALL_LIBDIR CMAKE_INSTALL_BINDIR
)

# Create version file
write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

# Install config files
install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

install(FILES
    ${CMAKE_SOURCE_DIR}/README.md
    DESTINATION .
)

if(PACKAGE_ROCKETSIM)
    # Install headers
    install(DIRECTORY ${RocketSim_INCLUDE_DIRS}/
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
        FILES_MATCHING PATTERN "*.h"
    )

    # Install cmake config
    install(DIRECTORY ${RocketSim_CMAKE_DIR}/
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/RocketSim
    )

    # Install libs
    install(DIRECTORY ${RocketSim_LIB_DIR}/
        DESTINATION ${${PROJECT_NAME}_INSTALL_LIB_DIR}
    )

    # Install libs
    install(DIRECTORY ${RocketSim_BIN_DIR}/
        DESTINATION ${${PROJECT_NAME}_INSTALL_BIN_DIR}
    )
endif()