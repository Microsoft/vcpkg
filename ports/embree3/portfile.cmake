vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO embree/embree
    REF v3.11.0
    SHA512 a20acb07103d322eebc85d41152210466f8d9b97e7a332589c692f649ee02079465f89561748ddc8448fb40bc63f2595d728cc31a927f7b95bea13446c5c775d
    HEAD_REF master
    PATCHES
        fix-path.patch
        fix-static-usage.patch
        cmake_policy.patch
)

string(COMPARE EQUAL ${VCPKG_LIBRARY_LINKAGE} static EMBREE_STATIC_LIB)
string(COMPARE EQUAL ${VCPKG_CRT_LINKAGE} static EMBREE_STATIC_RUNTIME)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    DISABLE_PARALLEL_CONFIGURE
    PREFER_NINJA
    OPTIONS
        -DEMBREE_ISPC_SUPPORT=OFF
        -DEMBREE_TUTORIALS=OFF
        -DEMBREE_STATIC_RUNTIME=${EMBREE_STATIC_RUNTIME}
        -DEMBREE_STATIC_LIB=${EMBREE_STATIC_LIB}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_fixup_cmake_targets()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()
if(APPLE)
    file(REMOVE ${CURRENT_PACKAGES_DIR}/uninstall.command ${CURRENT_PACKAGES_DIR}/debug/uninstall.command)
endif()
file(RENAME ${CURRENT_PACKAGES_DIR}/share/doc ${CURRENT_PACKAGES_DIR}/share/${PORT}/doc)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/usage DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})
file(INSTALL ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)