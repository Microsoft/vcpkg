vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO andlabs/libui
    REF fea45b2d5b75839be0af9acc842a147c5cba9295  # 2021-01-03
    SHA512 59f31e0b0afff0f41592f5edaa495b89275e1bc7329312145dcea2896aa2898658b60c187be8f805b4cf1c23ce1ae4171c637f115d716998569d5c53e103217b
    HEAD_REF master
)

vcpkg_configure_meson(
    SOURCE_PATH ${SOURCE_PATH}
#    PREFER_NINJA
)

vcpkg_install_meson()
vcpkg_fixup_pkgconfig()
vcpkg_copy_pdbs()

# vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/libui TARGET_PATH share/unofficial-libui)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include ${CURRENT_PACKAGES_DIR}/examples)

# Handle copyright
configure_file("${SOURCE_PATH}/LICENSE" "${CURRENT_PACKAGES_DIR}/share/libui/copyright" COPYONLY)
