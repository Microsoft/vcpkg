function(set_fatal_error)
    if(ARGC EQUAL 0)
        set(Z_VCPKG_UNIT_TEST_HAS_FATAL_ERROR "OFF" CACHE BOOL "" FORCE)
    else()
        set(Z_VCPKG_UNIT_TEST_HAS_FATAL_ERROR "ON" CACHE BOOL "" FORCE)
        set(Z_VCPKG_UNIT_TEST_FATAL_ERROR "${ARGV0}" CACHE STRING "" FORCE)
    endif()
endfunction()
function(set_has_error)
    set(Z_VCPKG_UNIT_TEST_HAS_ERROR ON CACHE BOOL "" FORCE)
endfunction()

macro(message level msg)
    if("${level}" STREQUAL "FATAL_ERROR")
        set_fatal_error("${msg}")
        return()
    else()
        _message("${level}" "${msg}")
    endif()
endmacro()

set(Z_VCPKG_UNIT_TEST_HAS_ERROR OFF CACHE BOOL "" FORCE)
set_fatal_error()

function(unit_test_check_variable_equal utcve_test utcve_variable utcve_value)
    cmake_language(EVAL CODE "${utcve_test}")
    if(Z_VCPKG_UNIT_TEST_HAS_FATAL_ERROR)
        set_fatal_error()
        set_has_error()
        message(STATUS "${utcve_test} had an unexpected FATAL_ERROR;
    expected: \"${utcve_value}\"")
        message(STATUS "FATAL_ERROR: ${Z_VCPKG_UNIT_TEST_FATAL_ERROR}")
        return()
    endif()

    if(NOT DEFINED "${utcve_variable}")
        message(STATUS "${utcve_test} failed to set ${utcve_variable};
    expected: \"${utcve_value}\"")
        set_has_error()
        return()
    endif()
    if(NOT "${${utcve_variable}}" STREQUAL "${utcve_value}")
        message(STATUS "${utcve_test} resulted in the wrong value for ${utcve_variable};
    expected: \"${utcve_value}\"
    actual  : \"${${utcve_variable}}\"")
        set_has_error()
        return()
    endif()
endfunction()

function(unit_test_ensure_fatal_error utcve_test)
    cmake_language(EVAL CODE "${utcve_test}")
    if(NOT Z_VCPKG_UNIT_TEST_HAS_FATAL_ERROR)
        set_has_error()
        message(STATUS "${utcve_test} was expected to be a FATAL_ERROR.")
    endif()
    set_fatal_error()
endfunction()

set(VCPKG_POLICY_EMPTY_PACKAGE enabled)

if("list" IN_LIST FEATURES)
    include("${CMAKE_CURRENT_LIST_DIR}/test-vcpkg_list.cmake")
endif()
if("function-arguments" IN_LIST FEATURES)
    include("${CMAKE_CURRENT_LIST_DIR}/test-z_vcpkg_function_arguments.cmake")
endif()

if(Z_VCPKG_UNIT_TEST_HAS_ERROR)
    _message(FATAL_ERROR "At least one test failed")
endif()
