include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO dnp3/opendnp3
    REF 2.3.2
    SHA512 41686b5c32234088a5af3c71769b0193deb10a95d623579508cc740f126f35c18796f761093cec12ead469f0088839a680cc7d137b2f762a80c1736d71c3d90a
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS -DSTATICLIBS=ON -DDNP3_TLS=ON
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

vcpkg_copy_pdbs()

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
