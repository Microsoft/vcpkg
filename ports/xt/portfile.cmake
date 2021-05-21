vcpkg_from_gitlab(
    GITLAB_URL https://gitlab.freedesktop.org/xorg
    OUT_SOURCE_PATH SOURCE_PATH
    REPO lib/libxt
    REF 93ffd50ccf04d02fc94565d8ee831c7b63d6d71a # 1.2
    SHA512  f96f611d0c1e53aef0c6e15407dbec1a79cb4820831f95ee1dba61a7ded54e46715925d3f4fdc910b5d23a05753e72b9d8067934cd68d990e84b6cdab2fbe40c
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
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

