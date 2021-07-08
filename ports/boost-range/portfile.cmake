# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/range
    REF boost-1.76.0
    SHA512 dc7801aad1bb271c28d9a0ec6e132b5b6992d4638b90c007e392148903acb27ef9bfe1273d00db181416e0325beb756eac26f458a360740889c521b8f5424fb4
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
