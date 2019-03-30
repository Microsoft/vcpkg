# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/smart_ptr
    REF boost-1.69.0
    SHA512 b11e39bde74287c2c9b24ea2c9509fb2f44714ee75e876e8c2c5754cf8c1c7a8f42570f7084393d031b4347abb1ac9715c779c19ecaf5917abb53e368c1e5868
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
