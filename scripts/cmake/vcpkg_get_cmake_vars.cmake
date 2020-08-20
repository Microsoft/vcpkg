## # vcpkg_get_cmake_vars
##
## Runs a cmake configure with a dummy project to extract certain cmake variables
##
## ## Usage
## ```cmake
## vcpkg_get_cmake_vars(
##     [OUTPUT_FILE <output_file_with_vars>]
##     [OPTIONS <-DUSE_THIS_IN_ALL_BUILDS=1>...]
## )
## ```
##
## ## Parameters
## ### OPTIONS
## Additional options to pass to the test configure call 
##
## ### OUTPUT_FILE
## Variable to return the path to the generated cmake file with the detected `CMAKE_` variables set as `VCKPG_DETECTED_`
##
## ## Notes
## If possible avoid usage in portfiles. 
##
## ## Examples
##
## * [vcpkg_configure_make](https://github.com/Microsoft/vcpkg/blob/master/scripts/cmake/vcpkg_configure_make.cmake)

function(vcpkg_get_cmake_vars)
    cmake_parse_arguments(PARSE_ARGV 0 _gcv "" "OUTPUT_FILE" "OPTIONS")

    if(_gcv_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "vcpkg_get_cmake_vars was passed unparsed arguments: '${_gcv_UNPARSED_ARGUMENTS}'")
    endif()

    if(NOT _gcv_OUTPUT_FILE)
        message(FATAL_ERROR "vcpkg_get_cmake_vars requires parameter OUTPUT_FILE!")
    endif()

    if(${_gcv_OUTPUT_FILE})
        debug_message("OUTPUT_FILE ${${_gcv_OUTPUT_FILE}}")
        list(APPEND _gcv_OPTIONS "-DVCPKG_OUTPUT_FILE=${${_gcv_OUTPUT_FILE}}")
    else()
        set(DEFAULT_OUT "${CURRENT_BUILDTREES_DIR}/cmake-vars-${TARGET_TRIPLET}.cmake.log") # So that the file gets included in CI artifacts.
        list(APPEND _gcv_OPTIONS "-DVCPKG_OUTPUT_FILE:PATH=${DEFAULT_OUT}")
        set(${_gcv_OUTPUT_FILE} "${DEFAULT_OUT}" PARENT_SCOPE)
    endif()

    set(VCPKG_BUILD_TYPE release)
    vcpkg_configure_cmake(
        SOURCE_PATH "${SCRIPTS}/get_cmake_vars"
        OPTIONS ${_gcv_OPTIONS}
        PREFER_NINJA
    )

    file(REMOVE "${CURRENT_BUILDTREES_DIR}/get-cmake-vars-${TARGET_TRIPLET}-out.log")
    file(REMOVE "${CURRENT_BUILDTREES_DIR}/get-cmake-vars-${TARGET_TRIPLET}-err.log")
    file(REMOVE_RECURSE "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-get-cmake-vars")
    file(RENAME "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel" "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-get-cmake-vars")
    if(NOT VCPKG_TARGET_IS_WINDOWS)
        set(LOGSUFFIX -rel)
    endif()
    file(RENAME "${CURRENT_BUILDTREES_DIR}/config-${TARGET_TRIPLET}${LOGSUFFIX}-out.log" "${CURRENT_BUILDTREES_DIR}/get-cmake-vars-${TARGET_TRIPLET}-out.log")
    file(RENAME "${CURRENT_BUILDTREES_DIR}/config-${TARGET_TRIPLET}${LOGSUFFIX}-err.log" "${CURRENT_BUILDTREES_DIR}/get-cmake-vars-${TARGET_TRIPLET}-err.log")
endfunction()
