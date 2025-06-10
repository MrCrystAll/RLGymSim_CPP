function(install_target)
	set(options)
	set(oneValueArgs TARGET_NAME INSTALL_CMAKEDIR)
	cmake_parse_arguments(EA "${options}" "${oneValueArgs}" "" ${ARGN})

	if(NOT EA_TARGET_NAME OR NOT EA_INSTALL_CMAKEDIR)
        message(FATAL_ERROR "extract_archive requires TARGET_NAME and INSTALL_CMAKEDIR")
    endif()

	install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include/${EA_TARGET_NAME}
		DESTINATION include
		FILES_MATCHING PATTERN "*.h"
	)

	install(TARGETS ${EA_TARGET_NAME}
		EXPORT ${EA_TARGET_NAME}Targets
		RUNTIME DESTINATION lib
		LIBRARY DESTINATION lib
		ARCHIVE DESTINATION lib
		INCLUDES DESTINATION include
	)

	# Export targets
	install(EXPORT ${EA_TARGET_NAME}Targets
		FILE ${EA_TARGET_NAME}Targets.cmake
		NAMESPACE ${EA_TARGET_NAME}::
		DESTINATION ${EA_INSTALL_CMAKEDIR}
	)

	# Install config and version files
	install(FILES "${CMAKE_CURRENT_BINARY_DIR}/${EA_TARGET_NAME}Config.cmake" "${CMAKE_CURRENT_BINARY_DIR}/${EA_TARGET_NAME}ConfigVersion.cmake" DESTINATION ${EA_INSTALL_CMAKEDIR})

endfunction()