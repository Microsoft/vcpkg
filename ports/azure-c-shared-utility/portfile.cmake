include(vcpkg_common_functions)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    message("azure-c-shared-utility only supports static linkage")
    set(VCPKG_LIBRARY_LINKAGE "static")
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Azure/azure-c-shared-utility
    REF 68ede5bbc58c7d976f3bd68325edec181c254e5e
    SHA512 97253c081cab90c7c879da9ecfa076be43d19fd0d442d91fcab8ab3149e792b868c363c56b5afc3e3880a18b400e663661d257237d2f1ef97544522a1cabcd5a
    HEAD_REF master
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_AS_DYNAMIC)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -Dskip_samples=ON
        -Duse_installed_dependencies=ON
        -Duse_default_uuid=ON
        -Dbuild_as_dynamic=${BUILD_AS_DYNAMIC}
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH cmake TARGET_PATH share/azure_c_shared_utility)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include ${CURRENT_PACKAGES_DIR}/debug/share)

file(COPY ${SOURCE_PATH}/configs/azure_iot_build_rules.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/azure-c-shared-utility)

file(INSTALL
    ${SOURCE_PATH}/LICENSE
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/azure-c-shared-utility RENAME copyright)

vcpkg_copy_pdbs()
