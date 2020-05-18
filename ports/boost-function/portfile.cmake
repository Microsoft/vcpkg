# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/function
    REF boost-1.73.0
    SHA512 5445ee22193ba369394f9a66dd47c13d89c080c7286ce12fea15f1e09b77dc036f7e037fba971dcce46a24f48824031a93d9d91ab6c4ddf841c4105c168652ac
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
