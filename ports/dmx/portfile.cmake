vcpkg_from_gitlab(
    GITLAB_URL https://gitlab.freedesktop.org/xorg
    OUT_SOURCE_PATH SOURCE_PATH
    REPO lib/libdmx
    REF  6056db9a2fa8ad1ea55f8b8e2cbf5972408d612f #1.1.4
    SHA512 f7b0a3fb26bc68e5dd27a0afa98ed29fed31956fd07f89b57171d7f9d9a0a87185876551dbf312b8d90a66fa50de06992cf9eb386fa98dd8133946de3c37e274
    HEAD_REF master # branch name
) 
set(ENV{ACLOCAL} "aclocal -I \"${CURRENT_INSTALLED_DIR}/share/xorg/aclocal/\"")

vcpkg_configure_make(
    SOURCE_PATH ${SOURCE_PATH}
    AUTOCONFIG
)

vcpkg_install_make()
vcpkg_fixup_pkgconfig(SYSTEM_LIBRARIES pthread)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

# # Handle copyright
file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/share/${PORT}/")
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

