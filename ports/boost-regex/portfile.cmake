# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/regex
    REF boost-1.67.0
    SHA512 e3b3aaaf866aa9e6a4148c545f4d4a4ab8037dc8882ed7cd4eecd7727976d1a137a4c4e5599283f5d6f3616e865369d80733070f571fdb990555e4769f59ab83
    HEAD_REF master
)

if("icu" IN_LIST FEATURES)
    set(REQUIREMENTS "<library>/user-config//icuuc <library>/user-config//icudt <library>/user-config//icuin <define>BOOST_HAS_ICU=1")
else()
    set(REQUIREMENTS)
endif()

include(${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
boost_modular_build(SOURCE_PATH ${SOURCE_PATH} REQUIREMENTS "${REQUIREMENTS}")
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
