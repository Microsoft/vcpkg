# header-only library
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ned14/outcome
    REF 34f3bd55e2bcaf246cb79efe64a5600e89b91b66 #v2.1.3
    SHA512 83eba50e2095e7c768dacb3af5f82db117c3451f1d5bc2f73d716608d56f7b73006ec33d0f3842fdefd076f0e82b72ece5777868712f75e83eac93aa8adf351c
    HEAD_REF develop
)

file(GLOB_RECURSE OUTCOME_HEADERS "${SOURCE_PATH}/single-header/*.hpp")
file(INSTALL ${OUTCOME_HEADERS} DESTINATION ${CURRENT_PACKAGES_DIR}/include)

file(INSTALL ${SOURCE_PATH}/Licence.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
