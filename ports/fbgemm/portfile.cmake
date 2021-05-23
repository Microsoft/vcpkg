vcpkg_fail_port_install(ON_ARCH "x86" ON_TARGET "uwp")

# The project's CMakeLists.txt uses Python to select source files. Check if it is available in advance.
vcpkg_find_acquire_program(PYTHON3)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO pytorch/fbgemm
    REF d4a6222bf4700b80271798ed391651c9e0dab490
    SHA512 56d44d8d98bc160c45595da0136e990018dd51cd8e828d073eedc52ae150c2007838e18612569f84df0b14e96c1fc3e44cef5d7f84d00b72d511492297005271
    HEAD_REF master
    PATCHES
        fix-cmakelists.patch
)

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DFBGEMM_BUILD_TESTS=OFF
        -DFBGEMM_BUILD_BENCHMARKS=OFF
        -DPYTHON_EXECUTABLE=${PYTHON3} # inject the path instead of find_package(Python)
)
vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(CONFIG_PATH share/cmake/${PORT})

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
# note: libtorch uses this private header
file(INSTALL ${SOURCE_PATH}/src/RefImplementations.h
     DESTINATION ${CURRENT_PACKAGES_DIR}/include/fbgemm/src
)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include ${CURRENT_PACKAGES_DIR}/debug/share)
