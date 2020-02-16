# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/range
    REF boost-1.72.0
    SHA512 6f815133807bca94c57b3013060bd7d5a23a7f06255fcc1dec4a11dc3b9611c9962aae80029583c2b0ff0aa31a2e195ce8c781d956d8d1a16db2320a60edefa6
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
