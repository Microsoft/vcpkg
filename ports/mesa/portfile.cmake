# zstd, drm (!windows), elfutils (!windows), wayland (!windows), wayland-protocols (!windows), xdamage, xshmfence (!windows), x11, xcb, xfixes, xext, xxf86vm, xrandr, xv, xvmc (!windows), egl-registry, opengl-registry, tool-meson
#LLVM (modules: bitwriter, core, coroutines, engine, executionengine, instcombine, mcdisassembler, mcjit, scalaropts, transformutils) found: YES 
IF(VCPKG_TARGET_IS_WINDOWS)
    vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY) # will built drop in replacement for opengl32.dll
endif()

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    list(APPEND MESA_OPTIONS -D default_library='static')
else()
    list(APPEND MESA_OPTIONS -D default_library='shared')
endif()

vcpkg_from_gitlab(
    GITLAB_URL https://gitlab.freedesktop.org
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mesa/mesa
    REF  df2977f871fc70ebd6be48c180d117189b5861b5 #v20.2.2
    SHA512 6c51d817fe265ea6405c4e8afbb516f30cf697d00cf39f162473ea8a59c202bcdfbfe4b6f7c4a6fd2d4e98eb4a1604cb5e0a02558338bf415e53fe5421cbfbbe
    HEAD_REF master # branch name
    PATCHES ${PATCHES} #patch name
) 
vcpkg_find_acquire_program(PYTHON3)
get_filename_component(PYTHON3_DIR "${PYTHON3}" DIRECTORY)
vcpkg_add_to_path("${PYTHON3_DIR}")
vcpkg_add_to_path("${PYTHON3_DIR}/Scripts")
if(DEFINED ENV{PYTHON})
    set(ENV_PYTHON_BACKUP "$ENV{PYTHON}")
endif()
set(ENV{PYTHON} "${PYTHON3}")


if (WIN32)
    set(PYTHON_OPTION "")
else()
    set(PYTHON_OPTION "--user")
endif()

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
    execute_process(COMMAND ${PYTHON3_DIR}/Scripts/pip${VCPKG_HOST_EXECUTABLE_SUFFIX} install mako ${PYTHON_OPTION})
    execute_process(COMMAND ${PYTHON3_DIR}/Scripts/pip${VCPKG_HOST_EXECUTABLE_SUFFIX} install setuptools ${PYTHON_OPTION})
else()
    execute_process(COMMAND ${PYTHON3_DIR}/easy_install${VCPKG_HOST_EXECUTABLE_SUFFIX} mako)
    execute_process(COMMAND ${PYTHON3_DIR}/easy_install${VCPKG_HOST_EXECUTABLE_SUFFIX} setuptools)
endif()
if(NOT VCPKG_TARGET_IS_WINDOWS)
    execute_process(COMMAND pip3 install setuptools mako)
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

list(APPEND MESA_OPTIONS -D shared-llvm='auto')
if("llvm" IN_LIST FEATURES)
    list(APPEND MESA_OPTIONS -D llvm='enabled')
else()
    list(APPEND MESA_OPTIONS -D llvm='disabled')
endif()

list(APPEND MESA_OPTIONS -D zstd='enabled')

if(VCPKG_TARGET_IS_WINDOWS)
    list(APPEND MESA_OPTIONS -D shared-glapi='disabled'
                             -D opengl='enabled'
                             
                             -D platforms=['windows']
                             #-D egl=true # not available on windows
                             #-D gles1=false
                             #-D gles2=false
                             #-D glvnd=false
                             #-D glx=gallium-xlib
                             -D gallium-drivers=['swr','swrast']
                             #-D osmesa=gallium
                             #-D dri-drivers=nouveau
                             #-D llvm=true
                             )
else()
    list(APPEND MESA_OPTIONS -D shared-glapi='disabled'
                             -D opengl='enabled'
                             #-D egl=true
                             #-D gles1=true
                             #-D gles2=true
    )
endif()

vcpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS 
        #-D gles-lib-suffix=_mesa
        #-D egl-lib-suffix=_mesa
        -D build-tests=false
        "${MESA_OPTIONS}"
    ADDITIONAL_BINARIES_NATIVE "python = '${PYTHON3}'"
)
vcpkg_install_meson()
vcpkg_fixup_pkgconfig(SYSTEM_LIBRARIES pthread)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

#installed by egl-registry
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/KHR)
file(REMOVE ${CURRENT_PACKAGES_DIR}/include/EGL/egl.h)
file(REMOVE ${CURRENT_PACKAGES_DIR}/include/EGL/eglext.h)
file(REMOVE ${CURRENT_PACKAGES_DIR}/include/EGL/eglplatform.h)

#installed by opengl-registry
set(_double_files include/GL/glcorearb.h include/GL/glext.h include/GL/glxext.h 
    include/GLES/egl.h include/GLES/gl.h include/GLES/glext.h include/GLES/glplatform.h 
    include/GLES2/gl2.h include/GLES2/gl2ext.h include/GLES2/gl2platform.h
    include/GLES3/gl3.h  include/GLES3/gl31.h include/GLES3/gl32.h include/GLES3/gl3platform.h)
foreach(_file ${_double_files})
    if(EXISTS "${CURRENT_PACKAGES_DIR}/${_file}")
        file(REMOVE "${CURRENT_PACKAGES_DIR}/${_file}")
    endif()
endforeach()
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/GLES)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/GLES2)
# # Handle copyright
file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(TOUCH "${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright")
