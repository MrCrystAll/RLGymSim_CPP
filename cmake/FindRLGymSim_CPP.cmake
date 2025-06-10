# FindRLGymSim_CPP.cmake

# This module defines:
#   RLGymSim_CPP_FOUND
#   RLGymSim_CPP_INCLUDE_DIRS
#   RLGymSim_CPP_LIBRARIES

find_path(RLGymSim_CPP_INCLUDE_DIR
    NAMES RLGymSim_CPP/Framework.h  # Replace with a known header file
    PATH_SUFFIXES RLGymSim_CPP
)

find_library(RLGymSim_CPP_LIBRARY
    NAMES RLGymSim_CPP
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(RLGymSim_CPP
    REQUIRED_VARS RLGymSim_CPP_LIBRARY RLGymSim_CPP_INCLUDE_DIR
    VERSION_VAR RLGymSim_CPP_VERSION
)

if(RLGymSim_CPP_FOUND)
    set(RLGymSim_CPP_LIBRARIES ${RLGymSim_CPP_LIBRARY})
    set(RLGymSim_CPP_INCLUDE_DIRS ${RLGymSim_CPP_INCLUDE_DIR})
endif()
