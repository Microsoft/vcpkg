include(vcpkg_common_functions)

vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

set(RAQM_VERSION_MAJOR 0)
set(RAQM_VERSION_MINOR 7)
set(RAQM_VERSION_MICRO 0)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO HOST-Oman/libraqm
    REF v${RAQM_VERSION_MAJOR}.${RAQM_VERSION_MINOR}.${RAQM_VERSION_MICRO}
    SHA512 fe2f5e5707334d72518e720adff4379666ba5c4c045531e92588c5f843d4f56111e7b66ea4e7a061621320fa98f13229624994a950a789a477674d3a359cb58c
    HEAD_REF master
)

file(COPY ${CURRENT_PORT_DIR}/FindFribidi.cmake DESTINATION ${SOURCE_PATH})
file(COPY ${CURRENT_PORT_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DCURRENT_PACKAGES_DIR=${CURRENT_PACKAGES_DIR}
        -DRAQM_VERSION_MAJOR=${RAQM_VERSION_MAJOR}
        -DRAQM_VERSION_MINOR=${RAQM_VERSION_MINOR}
        -DRAQM_VERSION_MICRO=${RAQM_VERSION_MICRO}
)

vcpkg_install_cmake()

vcpkg_copy_pdbs()

# Handle copyright
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/libraqm RENAME copyright)

# Post-build test for cmake libraries
vcpkg_test_cmake(PACKAGE_NAME raqm)
