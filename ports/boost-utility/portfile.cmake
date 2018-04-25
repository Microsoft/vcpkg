# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/utility
    REF boost-1.67.0
    SHA512 4123a71af8234789b2b68f2a3b6e13e7ad3e46484e8b06ee2159d7337d101a2b1c8b8e7ca70ce29f0b71802f45014e1db03253e1f6515a6ad2f9d5ebced77caf
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
