#[===[.md:
# vcpkg_copy_tools

Copy tools and all their DLL dependencies into the `tools` folder.

## Usage
```cmake
vcpkg_copy_tools(
    TOOL_NAMES <tool1>...
    [SEARCH_DIR <${CURRENT_PACKAGES_DIR}/bin>]
    [DESTINATION <${CURRENT_PACKAGES_DIR}/tools/${PORT}>]
    [DEPENDENCIES <dep1>...]
    [AUTO_CLEAN]
)
```
## Parameters
### TOOL_NAMES
A list of tool filenames without extension.

### SEARCH_DIR
The path to the directory containing the tools. This will be set to `${CURRENT_PACKAGES_DIR}/bin` if omitted.

### DESTINATION
Destination to copy the tools to. This will be set to `${CURRENT_PACKAGES_DIR}/tools/${PORT}` if omitted.

### DEPENDENCIES
A list of dynamic libraries a tool is likely to load at runtime, such as plugins,
or other Run-Time Dynamic Linking mechanisms like LoadLibrary or dlopen.
These libraries will be copied into the same directory as the tool
even if they are not statically determined as dependencies from inspection of their import tables.

### AUTO_CLEAN
Auto clean executables in `${CURRENT_PACKAGES_DIR}/bin` and `${CURRENT_PACKAGES_DIR}/debug/bin`.

## Examples

* [cpuinfo](https://github.com/microsoft/vcpkg/blob/master/ports/cpuinfo/portfile.cmake)
* [nanomsg](https://github.com/microsoft/vcpkg/blob/master/ports/nanomsg/portfile.cmake)
* [uriparser](https://github.com/microsoft/vcpkg/blob/master/ports/uriparser/portfile.cmake)
#]===]

function(vcpkg_copy_tools)
    # parse parameters such that semicolons in options arguments to COMMAND don't get erased
    cmake_parse_arguments(PARSE_ARGV 0 _vct "AUTO_CLEAN" "SEARCH_DIR;DESTINATION" "TOOL_NAMES;DEPENDENCIES")

    if(NOT DEFINED _vct_TOOL_NAMES)
        message(FATAL_ERROR "TOOL_NAMES must be specified.")
    endif()

    if(NOT DEFINED _vct_DESTINATION)
        set(_vct_DESTINATION "${CURRENT_PACKAGES_DIR}/tools/${PORT}")
    endif()

    if(NOT DEFINED _vct_SEARCH_DIR)
        set(_vct_SEARCH_DIR "${CURRENT_PACKAGES_DIR}/bin")
    elseif(NOT IS_DIRECTORY ${_vct_SEARCH_DIR})
        message(FATAL_ERROR "SEARCH_DIR ${_vct_SEARCH_DIR} is supposed to be a directory.")
    endif()

    foreach(tool_name IN LISTS _vct_TOOL_NAMES)
        set(tool_path "${_vct_SEARCH_DIR}/${tool_name}${VCPKG_TARGET_EXECUTABLE_SUFFIX}")
        set(tool_pdb "${_vct_SEARCH_DIR}/${tool_name}.pdb")
        if(EXISTS "${tool_path}")
            file(COPY "${tool_path}" DESTINATION "${_vct_DESTINATION}")
        else()
            message(FATAL_ERROR "Couldn't find this tool: ${tool_path}.")
        endif()
        if(EXISTS "${tool_pdb}")
            file(COPY "${tool_pdb}" DESTINATION "${_vct_DESTINATION}")
        endif()
    endforeach()

    vcpkg_copy_tool_dependencies(TOOL_DIR "${_vct_DESTINATION}" DEPENDENCIES "${_vct_DEPENDENCIES}")

    if(_vct_AUTO_CLEAN)
        vcpkg_clean_executables_in_bin(FILE_NAMES ${_vct_TOOL_NAMES})
    endif()
endfunction()
