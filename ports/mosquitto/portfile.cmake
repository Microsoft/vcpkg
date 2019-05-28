include(vcpkg_common_functions)

vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY ONLY_DYNAMIC_CRT)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO eclipse/mosquitto
    REF 697f984d3b78dca79f05281b2dc56e76d2029294
    SHA512 c4b41e45ef8058ceed6c2feb72531b28de4ae6bf7a8181fbef96833c6ffa7d08e13784ab10c4d3c5e3eef0e4880097eb92a78c2c234a3e12159ca394d910e340
    HEAD_REF master
    PATCHES
        win64-cmake.patch
        output_folders-cmake.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DWITH_SRV=OFF
        -DWITH_WEBSOCKETS=ON
        -DWITH_TLS=ON
        -DWITH_TLS_PSK=ON
        -DWITH_THREADING=ON
        -DDOCUMENTATION=OFF
    OPTIONS_RELEASE
        -DENABLE_DEBUG=OFF
    OPTIONS_DEBUG
        -DENABLE_DEBUG=ON
)

vcpkg_install_cmake()

# Remove debug/include
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

file(GLOB EXE ${CURRENT_PACKAGES_DIR}/bin/*.exe)
file(GLOB DEBUG_EXE ${CURRENT_PACKAGES_DIR}/debug/bin/*.exe)
file(REMOVE ${EXE})
file(REMOVE ${DEBUG_EXE})

file(INSTALL ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/mosquitto RENAME copyright)

# Copy pdb
vcpkg_copy_pdbs()
