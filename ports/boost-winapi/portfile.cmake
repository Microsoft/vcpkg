# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/winapi
    REF boost-1.67.0
    SHA512 1a0935132e8058b3f592406aaf6bb6fa8df6c96c35e61e09d84e39c6ab00c50b87346789d309fdfb7de8f6252134a76a59c0dc214fe1f4ee25d82c379cf63a3c
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
