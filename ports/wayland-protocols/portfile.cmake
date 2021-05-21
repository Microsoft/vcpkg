set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)

vcpkg_from_gitlab(
    GITLAB_URL https://gitlab.freedesktop.org
    OUT_SOURCE_PATH SOURCE_PATH
    REPO wayland/wayland-protocols
    REF  630fb089103a1d0eab1a684b853ab5c4d2b252aa #1.18
    SHA512 b9132ebe4a85556cdbf03bab2f874949b004f361c654c115b8a70ce25e582b153fbad7ff4b1b2206d456d5f8222f08129c002c7b80ae56495a5417d7b8bda0b1
    HEAD_REF master # branch name
) 

set(ENV{ACLOCAL} "aclocal -I ${CURRENT_INSTALLED_DIR}/share/wayland/aclocal/")

vcpkg_configure_make(
    SOURCE_PATH ${SOURCE_PATH}
    AUTOCONFIG
)

vcpkg_install_make()
if(EXISTS "${CURRENT_PACKAGES_DIR}/share/${PORT}/pkgconfig")
    file(INSTALL "${CURRENT_PACKAGES_DIR}/share/${PORT}/pkgconfig/" DESTINATION "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/")
    file(INSTALL "${CURRENT_PACKAGES_DIR}/share/${PORT}/pkgconfig/" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/")
endif()
vcpkg_fixup_pkgconfig()



file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
# # Handle copyright
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

