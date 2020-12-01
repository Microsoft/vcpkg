vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO clMathLibraries/clRNG
    REF 4a16519ddf52ee0a5f0b7e6288b0803b9019c13b
    SHA512 28bda5d2a156e7394917f8c40bd1e8e7b52cf680abc0ef50c2650b1d546c0a1d0bd47ceeccce3cd7c79c90a15494c3d27829e153613a7d8e18267ce7262eeb6e
    HEAD_REF master
    PATCHES
        001-build-fixup.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}/src
    PREFER_NINJA
    OPTIONS
        -DBUILD_TEST=OFF
        -DBUILD_CLIENT=OFF
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
if(VCPKG_TARGET_IS_WINDOWS)
    file(
        GLOB DEBUG_CRT_FILES
            ${CURRENT_PACKAGES_DIR}/debug/bin/concrt*.dll
            ${CURRENT_PACKAGES_DIR}/debug/bin/msvcp*.dll
            ${CURRENT_PACKAGES_DIR}/debug/bin/vcruntime*.dll)
    file(REMOVE ${DEBUG_CRT_FILES})
endif()

vcpkg_fixup_cmake_targets(CONFIG_PATH share/clrng)

vcpkg_copy_pdbs()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION ${CURRENT_PACKAGES_DIR}/share/clrng/copyright)
