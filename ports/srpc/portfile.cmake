vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO sogou/srpc
    REF 16f2114157065fcd087a7e24193d4ac5710208b8
    SHA512 382c8ef955086554f2b7c26b640a88fb33df63c139a1e028f290bb581c21be015f1ae776c0fa437b2766d587af01dd0044a1585c38fff367c8d1a92100cd9a69
    HEAD_REF master
    PATCHES
        use-lib-for-lz4-and-snappy.patch
        fix-bin-error.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    DISABLE_PARALLEL_CONFIGURE
)

vcpkg_install_cmake()

vcpkg_copy_tools(
    TOOL_NAMES srpc_generator
    AUTO_CLEAN
)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake TARGET_PATH share)

vcpkg_copy_pdbs()

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/srpc RENAME copyright)
