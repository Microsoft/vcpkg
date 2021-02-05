vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO artivis/manif
    REF 0.0.3
    SHA512 883e57423ce4a9e05f589d0f56045279b8291f565f5814ee013f1732cc3665165ede43189467c72b06fc652a69bfd3b2aab11cdaea50fa63bde8953bb5b74367
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)

vcpkg_install_cmake()


file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")


# Add the copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
