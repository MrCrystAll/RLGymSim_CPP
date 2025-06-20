include(FetchContent)
function(fetch_lib)
    set(options "")
    set(oneValueArgs OWNER REPO TAG ASSET_PATTERN PLATFORM)
    set(multiValueArgs "")
    cmake_parse_arguments(DOWNLOAD_LIB "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    # Validate required arguments
    if(NOT DOWNLOAD_LIB_OWNER)
        message(FATAL_ERROR "OWNER argument is required")
    endif()
    if(NOT DOWNLOAD_LIB_REPO)
        message(FATAL_ERROR "REPO argument is required")
    endif()
    if(NOT DOWNLOAD_LIB_TAG)
        message(FATAL_ERROR "TAG argument is required")
    endif()
    
    set(FETCH_NAME "${DOWNLOAD_LIB_REPO}")
    
    # Check if FetchContent has already been declared and populated for this library
    FetchContent_GetProperties(${FETCH_NAME})
    if(${FETCH_NAME}_POPULATED)
        message(STATUS "Library ${FETCH_NAME} already populated, skipping download")
        
        # Ensure variables are set in parent scope
        set(${FETCH_NAME}_SOURCE_DIR "${${FETCH_NAME}_SOURCE_DIR}" PARENT_SCOPE)
        set(${FETCH_NAME}_BINARY_DIR "${${FETCH_NAME}_BINARY_DIR}" PARENT_SCOPE)
        set(${FETCH_NAME}_FOUND TRUE PARENT_SCOPE)
        
        # Add to CMAKE_PREFIX_PATH if not already there
        if(DEFINED ${FETCH_NAME}_SOURCE_DIR AND ${FETCH_NAME}_SOURCE_DIR)
            list(FIND CMAKE_PREFIX_PATH "${${FETCH_NAME}_SOURCE_DIR}" PATH_INDEX)
            if(PATH_INDEX EQUAL -1)
                list(APPEND CMAKE_PREFIX_PATH "${${FETCH_NAME}_SOURCE_DIR}")
                set(CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH}" PARENT_SCOPE)
            endif()
        endif()
        
        return()
    endif()
    
    # Create a cache directory for downloaded assets
    set(CACHE_DIR "${CMAKE_BINARY_DIR}/_deps_cache")
    file(MAKE_DIRECTORY "${CACHE_DIR}")
    
    # Create a unique cache key based on owner, repo, and tag
    set(CACHE_KEY "${DOWNLOAD_LIB_OWNER}_${DOWNLOAD_LIB_REPO}_${DOWNLOAD_LIB_TAG}")
    set(CACHE_INFO_FILE "${CACHE_DIR}/${CACHE_KEY}.info")
    
    # Handle platform selection and set appropriate file patterns
    if(DOWNLOAD_LIB_PLATFORM)
        string(TOLOWER "${DOWNLOAD_LIB_PLATFORM}" PLATFORM_LOWER)
        if(PLATFORM_LOWER STREQUAL "windows" OR PLATFORM_LOWER STREQUAL "win")
            set(PLATFORM_PATTERNS "windows;win64;win32;x64-windows;x86-windows")
            if(NOT DOWNLOAD_LIB_ASSET_PATTERN)
                set(DOWNLOAD_LIB_ASSET_PATTERN "*.zip")  # Default for Windows
            endif()
        elseif(PLATFORM_LOWER STREQUAL "mac" OR PLATFORM_LOWER STREQUAL "macos" OR PLATFORM_LOWER STREQUAL "darwin")
            set(PLATFORM_PATTERNS "mac;macos;darwin;osx;x64-osx;arm64-osx")
            if(NOT DOWNLOAD_LIB_ASSET_PATTERN)
                set(DOWNLOAD_LIB_ASSET_PATTERN "*.tar.gz")  # Default for Mac
            endif()
        elseif(PLATFORM_LOWER STREQUAL "linux")
            set(PLATFORM_PATTERNS "linux;x64-linux;amd64;x86_64")
            if(NOT DOWNLOAD_LIB_ASSET_PATTERN)
                set(DOWNLOAD_LIB_ASSET_PATTERN "*.tar.gz")  # Default for Linux
            endif()
        else()
            message(FATAL_ERROR "Unsupported platform: ${DOWNLOAD_LIB_PLATFORM}. Supported platforms: windows, mac, linux")
        endif()
        message(STATUS "Filtering assets for platform: ${DOWNLOAD_LIB_PLATFORM}")
    else()
        # Auto-detect platform if not specified
        if(WIN32)
            set(PLATFORM_PATTERNS "windows;win64;win32;x64-windows;x86-windows")
            if(NOT DOWNLOAD_LIB_ASSET_PATTERN)
                set(DOWNLOAD_LIB_ASSET_PATTERN "*.zip")  # Default for Windows
            endif()
            message(STATUS "Auto-detected platform: Windows")
        elseif(APPLE)
            set(PLATFORM_PATTERNS "mac;macos;darwin;osx;x64-osx;arm64-osx")
            if(NOT DOWNLOAD_LIB_ASSET_PATTERN)
                set(DOWNLOAD_LIB_ASSET_PATTERN "*.tar.gz")  # Default for Mac
            endif()
            message(STATUS "Auto-detected platform: macOS")
        elseif(UNIX)
            set(PLATFORM_PATTERNS "linux;x64-linux;amd64;x86_64")
            if(NOT DOWNLOAD_LIB_ASSET_PATTERN)
                set(DOWNLOAD_LIB_ASSET_PATTERN "*.tar.gz")  # Default for Linux
            endif()
            message(STATUS "Auto-detected platform: Linux")
        else()
            message(WARNING "Could not detect platform, proceeding without platform filtering")
            set(PLATFORM_PATTERNS "")
            if(NOT DOWNLOAD_LIB_ASSET_PATTERN)
                set(DOWNLOAD_LIB_ASSET_PATTERN "*.zip")  # Fallback default
            endif()
        endif()
    endif()
    
    # Include platform and pattern in cache key for more specific caching
    string(REPLACE ";" "_" PLATFORM_PATTERNS_STR "${PLATFORM_PATTERNS}")
    set(CACHE_KEY "${CACHE_KEY}_${PLATFORM_PATTERNS_STR}_${DOWNLOAD_LIB_ASSET_PATTERN}")
    string(REPLACE "*" "STAR" CACHE_KEY "${CACHE_KEY}")
    string(REPLACE "." "DOT" CACHE_KEY "${CACHE_KEY}")
    set(CACHE_INFO_FILE "${CACHE_DIR}/${CACHE_KEY}.info")
    
    # Check if we have a cached version
    set(CACHED_ASSET_PATH "")
    if(EXISTS "${CACHE_INFO_FILE}")
        file(READ "${CACHE_INFO_FILE}" CACHE_INFO)
        string(STRIP "${CACHE_INFO}" CACHED_ASSET_PATH)
        
        if(EXISTS "${CACHED_ASSET_PATH}")
            message(STATUS "Using cached asset: ${CACHED_ASSET_PATH}")
            
            # Use the cached file with FetchContent
            file(TO_CMAKE_PATH "${CACHED_ASSET_PATH}" CMAKE_ASSET_PATH)
            
            FetchContent_Declare(
                ${FETCH_NAME}
                URL "${CMAKE_ASSET_PATH}"
                DOWNLOAD_EXTRACT_TIMESTAMP FALSE
            )
            FetchContent_MakeAvailable(${FETCH_NAME})
            
            # Set up variables and return
            FetchContent_GetProperties(${FETCH_NAME})
            message(STATUS "FetchContent made available from cache: ${FETCH_NAME}")
            message(STATUS "Source directory: ${${FETCH_NAME}_SOURCE_DIR}")
            message(STATUS "Binary directory: ${${FETCH_NAME}_BINARY_DIR}")
            
            # Set variables in parent scope
            if(DEFINED ${FETCH_NAME}_SOURCE_DIR AND ${FETCH_NAME}_SOURCE_DIR)
                list(APPEND CMAKE_PREFIX_PATH "${${FETCH_NAME}_SOURCE_DIR}")
                set(CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH}" PARENT_SCOPE)
                set(${FETCH_NAME}_SOURCE_DIR "${${FETCH_NAME}_SOURCE_DIR}" PARENT_SCOPE)
                set(${FETCH_NAME}_BINARY_DIR "${${FETCH_NAME}_BINARY_DIR}" PARENT_SCOPE)
                message(STATUS "Added ${${FETCH_NAME}_SOURCE_DIR} to CMAKE_PREFIX_PATH")
            endif()
            
            set(${FETCH_NAME}_FOUND TRUE PARENT_SCOPE)
            return()
        else()
            message(STATUS "Cached asset file no longer exists, will re-download")
            file(REMOVE "${CACHE_INFO_FILE}")
        endif()
    endif()
    
    # Check for GitHub token
    if(NOT DEFINED GITHUB_TOKEN AND (NOT DEFINED ENV{GITHUB_TOKEN} AND NOT DEFINED ENV{VOID_PAT}))
        message(FATAL_ERROR "GITHUB_TOKEN environment variable or CMake variable required")
    endif()
    
    if(DEFINED ENV{GITHUB_TOKEN})
        set(TOKEN $ENV{GITHUB_TOKEN})
    elseif(DEFINED ENV{VOID_PAT})
        set(TOKEN $ENV{VOID_PAT})
    else()
        set(TOKEN ${GITHUB_TOKEN})
    endif()
    
    # GitHub API URL to get release by tag
    set(API_URL "https://api.github.com/repos/${DOWNLOAD_LIB_OWNER}/${DOWNLOAD_LIB_REPO}/releases/tags/${DOWNLOAD_LIB_TAG}")
    set(API_RESPONSE_FILE "${CMAKE_BINARY_DIR}/github_release_${DOWNLOAD_LIB_REPO}_${DOWNLOAD_LIB_TAG}.json")
    
    message(STATUS "Fetching release info for ${DOWNLOAD_LIB_OWNER}/${DOWNLOAD_LIB_REPO}:${DOWNLOAD_LIB_TAG}")
    
    # Download release info from GitHub API
    file(DOWNLOAD "${API_URL}" "${API_RESPONSE_FILE}"
        HTTPHEADER "Authorization: token ${TOKEN}"
        HTTPHEADER "Accept: application/vnd.github.v3+json"
        STATUS API_STATUS
    )
    
    # Check API call status
    list(GET API_STATUS 0 STATUS_CODE)
    if(NOT STATUS_CODE EQUAL 0)
        list(GET API_STATUS 1 ERROR_MESSAGE)
        message(FATAL_ERROR "Failed to fetch release info: ${ERROR_MESSAGE}")
    endif()
    
    # Read and parse the JSON response to get asset information
    file(READ "${API_RESPONSE_FILE}" API_RESPONSE)
    
    # Extract asset ID and name instead of browser_download_url
    # First, convert wildcard pattern to regex pattern
    string(REPLACE "*" ".*" REGEX_PATTERN "${DOWNLOAD_LIB_ASSET_PATTERN}")
    string(REPLACE "." "\\." REGEX_PATTERN "${REGEX_PATTERN}")
    
    # Extract all assets with their IDs and names
    string(REGEX MATCHALL "\"id\"[^,]*,[^}]*\"name\"[^\"]*\"([^\"]*${REGEX_PATTERN}[^\"]*)" ASSET_MATCHES "${API_RESPONSE}")
    
    if(NOT ASSET_MATCHES)
        message(FATAL_ERROR "No assets matching pattern '${DOWNLOAD_LIB_ASSET_PATTERN}' found in release ${DOWNLOAD_LIB_TAG}")
    endif()
    
    # Filter assets by platform if platform patterns are defined
    set(FILTERED_ASSET_MATCHES "")
    if(PLATFORM_PATTERNS)
        foreach(ASSET_MATCH ${ASSET_MATCHES})
            string(REGEX REPLACE "\"id\"[^,]*,[^}]*\"name\"[^\"]*\"([^\"]*)" "\\1" ASSET_NAME "${ASSET_MATCH}")
            string(TOLOWER "${ASSET_NAME}" ASSET_NAME_LOWER)
            
            foreach(PATTERN ${PLATFORM_PATTERNS})
                if(ASSET_NAME_LOWER MATCHES "${PATTERN}")
                    list(APPEND FILTERED_ASSET_MATCHES "${ASSET_MATCH}")
                    break()
                endif()
            endforeach()
        endforeach()
        
        if(NOT FILTERED_ASSET_MATCHES)
            message(FATAL_ERROR "No assets matching platform '${DOWNLOAD_LIB_PLATFORM}' and pattern '${DOWNLOAD_LIB_ASSET_PATTERN}' found in release ${DOWNLOAD_LIB_TAG}")
        endif()
        
        set(ASSET_MATCHES "${FILTERED_ASSET_MATCHES}")
    endif()
    
    # Extract asset ID and name from the first match
    list(GET ASSET_MATCHES 0 FIRST_ASSET_MATCH)
    string(REGEX REPLACE ".*\"id\"[^:]*:([^,]*),.*\"name\"[^\"]*\"([^\"]*)" "\\1;\\2" ASSET_INFO "${FIRST_ASSET_MATCH}")
    list(GET ASSET_INFO 0 ASSET_ID)
    list(GET ASSET_INFO 1 ASSET_NAME)
    
    # Trim any whitespace from asset ID
    string(STRIP "${ASSET_ID}" ASSET_ID)
    string(STRIP "${ASSET_NAME}" ASSET_NAME)
    
    # Use the GitHub API asset endpoint instead of browser_download_url
    set(ASSET_API_URL "https://api.github.com/repos/${DOWNLOAD_LIB_OWNER}/${DOWNLOAD_LIB_REPO}/releases/assets/${ASSET_ID}")
    
    message(STATUS "Found asset: ${ASSET_NAME} (ID: ${ASSET_ID})")
    message(STATUS "Downloading from API endpoint: ${ASSET_API_URL}")
    
    # Download to cache directory instead of build directory
    set(CACHED_ASSET_PATH "${CACHE_DIR}/${ASSET_NAME}")
    file(DOWNLOAD "${ASSET_API_URL}" "${CACHED_ASSET_PATH}"
        HTTPHEADER "Authorization: Bearer ${TOKEN}"
        HTTPHEADER "Accept: application/octet-stream"
        STATUS DOWNLOAD_STATUS
        SHOW_PROGRESS
    )
    
    # Check download status
    list(GET DOWNLOAD_STATUS 0 DOWNLOAD_STATUS_CODE)
    if(NOT DOWNLOAD_STATUS_CODE EQUAL 0)
        list(GET DOWNLOAD_STATUS 1 DOWNLOAD_ERROR_MESSAGE)
        message(FATAL_ERROR "Failed to download asset: ${DOWNLOAD_ERROR_MESSAGE}")
    endif()
    
    # Save cache info
    file(WRITE "${CACHE_INFO_FILE}" "${CACHED_ASSET_PATH}")
    
    # Clean up API response file
    file(REMOVE "${API_RESPONSE_FILE}")
    
    # Now use FetchContent with the cached file
    file(TO_CMAKE_PATH "${CACHED_ASSET_PATH}" CMAKE_ASSET_PATH)
    
    FetchContent_Declare(
        ${FETCH_NAME}
        URL "${CMAKE_ASSET_PATH}"
        DOWNLOAD_EXTRACT_TIMESTAMP FALSE
    )
    FetchContent_MakeAvailable(${FETCH_NAME})

    # Check if already populated to avoid double processing
    FetchContent_GetProperties(${FETCH_NAME})
    
    # Now the _SOURCE_DIR and _BINARY_DIR variables should be available
    message(STATUS "FetchContent made available: ${FETCH_NAME}")
    message(STATUS "Source directory: ${${FETCH_NAME}_SOURCE_DIR}")
    message(STATUS "Binary directory: ${${FETCH_NAME}_BINARY_DIR}")
    
    # Add the source directory to CMAKE_PREFIX_PATH so find_package can locate it
    if(DEFINED ${FETCH_NAME}_SOURCE_DIR AND ${FETCH_NAME}_SOURCE_DIR)
        list(APPEND CMAKE_PREFIX_PATH "${${FETCH_NAME}_SOURCE_DIR}")
        set(CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH}" PARENT_SCOPE)
        
        # Also set the source dir variable in parent scope for external use
        set(${FETCH_NAME}_SOURCE_DIR "${${FETCH_NAME}_SOURCE_DIR}" PARENT_SCOPE)
        set(${FETCH_NAME}_BINARY_DIR "${${FETCH_NAME}_BINARY_DIR}" PARENT_SCOPE)
        
        message(STATUS "Added ${${FETCH_NAME}_SOURCE_DIR} to CMAKE_PREFIX_PATH")
    else()
        message(WARNING "${FETCH_NAME}_SOURCE_DIR is not set after FetchContent_MakeAvailable")
        # Fallback: try to determine the source directory manually
        get_property(FETCHCONTENT_BASE_DIR_VALUE GLOBAL PROPERTY FETCHCONTENT_BASE_DIR)
        if(NOT FETCHCONTENT_BASE_DIR_VALUE)
            set(FETCHCONTENT_BASE_DIR_VALUE "${CMAKE_BINARY_DIR}/_deps")
        endif()
        set(FALLBACK_SOURCE_DIR "${FETCHCONTENT_BASE_DIR_VALUE}/${FETCH_NAME}-src")
        if(EXISTS "${FALLBACK_SOURCE_DIR}")
            message(STATUS "Using fallback source directory: ${FALLBACK_SOURCE_DIR}")
            list(APPEND CMAKE_PREFIX_PATH "${FALLBACK_SOURCE_DIR}")
            set(CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH}" PARENT_SCOPE)
            set(${FETCH_NAME}_SOURCE_DIR "${FALLBACK_SOURCE_DIR}" PARENT_SCOPE)
        endif()
    endif()
    
    # Set a variable to indicate the library is available
    set(${FETCH_NAME}_FOUND TRUE PARENT_SCOPE)
endfunction()