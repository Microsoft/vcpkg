include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/arb-2.11.1)
vcpkg_from_github(
    OUT_SOURCE_PATH ${SOURCE_PATH}
    REPO fredrik-johansson/arb
    REF 2.11.1
    SHA512 7a014da5208b55f20c7a3cd3eb51070b09ae107b04cbbd6329925780c2ab4d7c38e1fb3619f21456fa806939818370fcae921f59eb013661b6bdd3d0971e3353
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()


# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/mpfr)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/mpfr/COPYING ${CURRENT_PACKAGES_DIR}/share/mpfr/copyright)
