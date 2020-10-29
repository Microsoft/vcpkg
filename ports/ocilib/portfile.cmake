vcpkg_fail_port_install(ON_ARCH "arm" ON_TARGET "uwp")

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO vrogier/ocilib
    REF 8573bce60d4aa4ac421445149003424fc7a69e6d v4.7.1
    SHA512 862c2df2f8e356bfafda32bba2c4564464104afea047b6297241a5ec2da9e1d73f3cd33f55e5bcd0018fb1b3625e756c22baf6821ab51c789359266f989137c8
    HEAD_REF master
    PATCHES
        #out_of_source_build_version_file_configure.patch
)

if(VCPKG_TARGET_IS_WINDOWS)
    if(VCPKG_PLATFORM_TOOLSET MATCHES "v142")
        set(SOLUTION_TYPE vs2019)
        set(OCILIB_ARCH_X86 x86)
        set(OCILIB_ARCH_X64 x64)
    elseif(VCPKG_PLATFORM_TOOLSET MATCHES "v141")
        set(SOLUTION_TYPE vs2017)
        set(OCILIB_ARCH_X86 Win32)
        set(OCILIB_ARCH_X64 Win64)
    else()
        set(SOLUTION_TYPE vs2015)
        set(OCILIB_ARCH_X86 Win32)
        set(OCILIB_ARCH_X64 Win64)
    endif()
    
    if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x86")
        set(PLATFORM ${OCILIB_ARCH_X86})
    else()
        set(PLATFORM ${OCILIB_ARCH_X64})
    endif()
    
    # There is no debug configuration
    # As it is a C library, build the release configuration and copy its output to the debug folder
    set(VCPKG_BUILD_TYPE release)
    vcpkg_install_msbuild(
        SOURCE_PATH ${SOURCE_PATH}
        PROJECT_SUBPATH proj/dll/ocilib_dll_${SOLUTION_TYPE}.sln
        INCLUDES_SUBPATH include
        LICENSE_SUBPATH LICENSE
        RELEASE_CONFIGURATION "Release - ANSI"
        PLATFORM ${PLATFORM}
        USE_VCPKG_INTEGRATION
        ALLOW_ROOT_INCLUDES)

    file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/debug)
    file(COPY ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/lib DESTINATION ${CURRENT_PACKAGES_DIR}/debug)
else()
    vcpkg_configure_make(
        COPY_SOURCE
        AUTOCONFIG
        SOURCE_PATH ${SOURCE_PATH}
        OPTIONS 
            --with-oracle-import=runtime
    )

    vcpkg_install_make()

    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
    file(RENAME ${CURRENT_PACKAGES_DIR}/share/doc/${PORT} ${CURRENT_PACKAGES_DIR}/share/${PORT})
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/doc)
    file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
endif()
