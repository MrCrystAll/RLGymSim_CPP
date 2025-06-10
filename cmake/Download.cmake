function(fetch_and_extract_from_scripts)
    set(options)
    set(oneValueArgs URL EXTRACT_DIR ARCHIVE_NAME)
    set(multiValueArgs)
    cmake_parse_arguments(EA "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(NOT EA_URL)
        message(FATAL_ERROR "fetch_and_extract_from_scripts: URL argument is required")
    endif()

    if(NOT EA_EXTRACT_DIR)
        message(FATAL_ERROR "fetch_and_extract_from_scripts: EXTRACT_DIR argument is required")
    endif()

    set(SH_SCRIPT "${CMAKE_SOURCE_DIR}/cmake/utils/download_extract.sh")
    set(BAT_SCRIPT "${CMAKE_SOURCE_DIR}/cmake/utils/download_extract.bat")


    if(EXISTS "${EA_EXTRACT_DIR}")
        message(STATUS "Dependency already present in ${EA_EXTRACT_DIR}, skipping download.")
        return()
     endif()

  # Create destination folder for the archive if needed
  file(MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/external")

  set(archive_path "${CMAKE_BINARY_DIR}/external/${EA_ARCHIVE_NAME}")

  message(STATUS "ARCHIVE NAME: ${EA_ARCHIVE_NAME}")
  message(STATUS "EXTRACT DIR: ${EA_EXTRACT_DIR}")
  message(STATUS "URL: ${EA_URL}")

  if(NOT EXISTS "${archive_path}")
    message(STATUS "Downloading ${EA_URL} to ${archive_path} ...")
    file(DOWNLOAD
      "${EA_URL}"
      "${archive_path}"
      SHOW_PROGRESS
      STATUS status
      LOG log)
    list(GET status 0 status_code)
    if(NOT status_code EQUAL 0)
      message(FATAL_ERROR "Failed to download ${EA_URL}: ${log}")
    endif()
  else()
    message(STATUS "Archive ${archive_path} already downloaded.")
  endif()

  message(STATUS "Extracting ${archive_path}...")
  if(UNIX)
        execute_process(
            COMMAND bash "${SH_SCRIPT}" "${archive_path}" "${EA_EXTRACT_DIR}"
            RESULT_VARIABLE res
        )
    elseif(WIN32)
        execute_process(
            COMMAND cmd.exe /c "${BAT_SCRIPT}" "${archive_path}" "${EA_EXTRACT_DIR}"
            RESULT_VARIABLE res
        )
    endif()

    if(NOT res EQUAL 0)
        message(FATAL_ERROR "Extraction failed")
    else()
        message(STATUS "Extraction successful")
    endif()
endfunction()
