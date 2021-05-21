if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    #set(PATCHES meson.build.patch)
endif()
vcpkg_from_gitlab(
    GITLAB_URL https://gitlab.freedesktop.org
    OUT_SOURCE_PATH SOURCE_PATH
    REPO xorg/xserver
    REF  bc111a2e67e16d4e6d4f3196ab86c22c1e278c45 #v1.20.10
    SHA512 928364bf9a7cc7f48d48154937c99ed5cbcc4dd96d13bb7ab947b54cdfcccd5e16104a0ac4b69e0362a956ad98b22760d7cdcbaa0d43ea6e57398bd0f8b5c7a4
    #REF  f84ad082557f9cde6b8faa373eca6a0a89ba7d56 #v1.20.8
    #SHA512 105bf5fa2875315bed4afc355607243b954beaf6a484069b58e37ef161bdd6691a815dca410acbf777683a7b2b880f636b8499fb161305b7c42753b1aecb1de3
    HEAD_REF master # branch name
    PATCHES ${PATCHES} #patch name
) 
#fix bzip pkgconfig
#fix freetype pkgconfig
#fix libpngs
set(ENV{ACLOCAL} "aclocal -I \"${CURRENT_INSTALLED_DIR}/share/xorg/aclocal/\"")
vcpkg_find_acquire_program(PYTHON3)
get_filename_component(PYTHON3_DIR "${PYTHON3}" DIRECTORY)
vcpkg_add_to_path("${PYTHON3_DIR}")
file(TO_NATIVE_PATH "${PYTHON3}" PYTHON3_NATIVE)
set(ENV{PYTHON3} "${PYTHON3_NATIVE}")

vcpkg_add_to_path("${PYTHON3_DIR}/Scripts")

set(PYTHON_OPTION "--user")
if(NOT EXISTS ${PYTHON3_DIR}/easy_install${VCPKG_HOST_EXECUTABLE_SUFFIX})
    if(NOT EXISTS ${PYTHON3_DIR}/Scripts/pip${VCPKG_HOST_EXECUTABLE_SUFFIX})
        vcpkg_from_github(
            OUT_SOURCE_PATH PYFILE_PATH
            REPO pypa/get-pip
            REF 309a56c5fd94bd1134053a541cb4657a4e47e09d #2019-08-25
            SHA512 bb4b0745998a3205cd0f0963c04fb45f4614ba3b6fcbe97efe8f8614192f244b7ae62705483a5305943d6c8fedeca53b2e9905aed918d2c6106f8a9680184c7a
            HEAD_REF master
        )
        execute_process(COMMAND ${PYTHON3_DIR}/python${VCPKG_HOST_EXECUTABLE_SUFFIX} ${PYFILE_PATH}/get-pip.py ${PYTHON_OPTION})
    endif()
    execute_process(COMMAND ${PYTHON3_DIR}/easy_install${VCPKG_HOST_EXECUTABLE_SUFFIX} lxml)
endif()

vcpkg_find_acquire_program(FLEX)
get_filename_component(FLEX_DIR "${FLEX}" DIRECTORY )
vcpkg_add_to_path(PREPEND "${FLEX_DIR}")
vcpkg_find_acquire_program(BISON)
get_filename_component(BISON_DIR "${BISON}" DIRECTORY )
vcpkg_add_to_path(PREPEND "${BISON_DIR}")

if(WIN32) # WIN32 HOST probably has win_flex and win_bison!
    if(NOT EXISTS "${FLEX_DIR}/flex${VCPKG_HOST_EXECUTABLE_SUFFIX}")
        file(CREATE_LINK "${FLEX}" "${FLEX_DIR}/flex${VCPKG_HOST_EXECUTABLE_SUFFIX}")
    endif()
    if(NOT EXISTS "${BISON_DIR}/BISON${VCPKG_HOST_EXECUTABLE_SUFFIX}")
        file(CREATE_LINK "${BISON}" "${BISON_DIR}/bison${VCPKG_HOST_EXECUTABLE_SUFFIX}")
    endif()
endif()

if(0)
    if(VCPKG_TARGET_IS_WINDOWS)
        set(OPTIONS 
            --enable-windowsdri=no
            --enable-windowswm=no
            --enable-libdrm=no
            --enable-pciaccess=no
            
            )
         set(ENV{CPP} "cl_cpp_wrapper")
    endif()

    vcpkg_configure_make(
        SOURCE_PATH ${SOURCE_PATH}
        AUTOCONFIG
        OPTIONS ${OPTIONS}
                --enable-xnest=no
    )

    vcpkg_install_make()
else()
   
    if("xwayland" IN_LIST FEATURES)
        list(APPEND OPTIONS -Dxwayland=true)
    else()
        list(APPEND OPTIONS -Dxwayland=false)
    endif()
    if("xnest" IN_LIST FEATURES)
        list(APPEND OPTIONS -Dxnest=true)
    else()
        list(APPEND OPTIONS -Dxnest=false)
    endif()
    if("xephyr" IN_LIST FEATURES)
        list(APPEND OPTIONS -Dxephyr=true)
    else()
        list(APPEND OPTIONS -Dxephyr=false)
    endif()
    if("xorg" IN_LIST FEATURES)
        list(APPEND OPTIONS -Dxorg=true)
    else()
        list(APPEND OPTIONS -Dxorg=false)
    endif()
    if(VCPKG_TARGET_IS_WINDOWS)
        string(APPEND VCPKG_C_FLAGS " /DYY_NO_UNISTD_H")
        string(APPEND VCPKG_CXX_FLAGS " /DYY_NO_UNISTD_H")
        list(APPEND OPTIONS -Dglx=false) #Requires Mesa3D for gl.pc
        list(APPEND OPTIONS -Dsecure-rpc=false) #Problem encountered: secure-rpc requested, but neither libtirpc or libc RPC support were found
        list(APPEND OPTIONS -Dxvfb=false) #hw\vfb\meson.build:7:0: ERROR: '' is not a target.
        list(APPEND OPTIONS -Dglamor=false)
        list(APPEND OPTIONS -Dlinux_apm=false)
        list(APPEND OPTIONS -Dlinux_acpi=false)
        list(APPEND OPTIONS -Dxwin=true)
        set(ENV{INCLUDE} "$ENV{INCLUDE};${CURRENT_INSTALLED_DIR}/include")
    else()
        if("xwin" IN_LIST FEATURES)
            list(APPEND OPTIONS -Dxwin=true)
        else()
            list(APPEND OPTIONS -Dxwin=false)
        endif()
    endif()

    #if(WIN32)
    #    vcpkg_acquire_msys(MSYS_ROOT PACKAGES pkg-config)
    #    vcpkg_add_to_path("${MSYS_ROOT}/usr/bin")
    #endif()

    vcpkg_configure_meson(
        SOURCE_PATH "${SOURCE_PATH}"
        OPTIONS ${OPTIONS}
    )
    vcpkg_install_meson()
endif()

vcpkg_fixup_pkgconfig(SYSTEM_LIBRARIES pthread)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/var" "${CURRENT_PACKAGES_DIR}/var")

# Handle copyright
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/tools/${PORT}")
set(TOOLS cvt gtf Xorg Xvfb Xwayland Xwin)
foreach(_tool ${TOOLS})
    if(EXISTS "${CURRENT_PACKAGES_DIR}/bin/${_tool}${VCPKG_TARGET_EXECUTABLE_SUFFIX}")
        file(RENAME "${CURRENT_PACKAGES_DIR}/bin/${_tool}${VCPKG_TARGET_EXECUTABLE_SUFFIX}" "${CURRENT_PACKAGES_DIR}/tools/${PORT}/${_tool}${VCPKG_TARGET_EXECUTABLE_SUFFIX}")
    endif()
endforeach()

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static" OR NOT VCPKG_TARGET_IS_WINDOWS)
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()