#header-only library
include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO glassechidna/zxing-cpp
    REF 5aad474
    SHA512 a079ad47171224de4469e76bf0779b6ebc9c6dfb3604bd5dbf5e6e5f321d9e6255f689daa749855f8400023602f1773214013c006442e9b32dd4b8146c888c02
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH "lib/zxing/cmake")

file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools/zxing)
file(COPY ${CURRENT_PACKAGES_DIR}/bin/zxing.exe DESTINATION ${CURRENT_PACKAGES_DIR}/tools/zxing)
vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/zxing)

vcpkg_copy_pdbs()
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib/zxing)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib/pkgconfig)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/bin)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib/zxing)

# Handle copyright
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/share/zxing)
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/zxing)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/zxing/COPYING ${CURRENT_PACKAGES_DIR}/share/zxing/copyright)
