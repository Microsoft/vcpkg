vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO NanoComp/meep
    REF ad8986b622631232324fc7a100fb726a297f22f3
    SHA512 2546a0e5c40d6532119279809571b68e9fd2d21af719f9b49cae315e3810c0adbf9fe5fe62e9bc7726ede3487dd7ad6fca5c49bd3adbe842f6598f29dd303ca4
    HEAD_REF master
)

include(vcpkg_find_fortran)
vcpkg_find_fortran(FORTRAN_CMAKE)

if(VCPKG_HOST_IS_WINDOWS)
    set(ENV{FC} "gfortran")
    message(STATUS "Switching to MinGW toolchain, including ${SCRIPTS}/toolchains/mingw.cmake")
    include("${SCRIPTS}/toolchains/mingw.cmake")
    set(ENV{FFLAGS} "-mabi=ms ${MACHINE_FLAG} ${VCPKG_Fortran_FLAGS}")
    vcpkg_acquire_msys(MSYS_ROOT PACKAGES autoconf make)
    vcpkg_add_to_path("${MSYS_ROOT}/usr/bin")
endif()

vcpkg_configure_make(
    AUTOCONFIG
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        --without-python
        --without-scheme
        --without-hdf5
    OPTIONS_DEBUG
        --enable-debug
)

vcpkg_install_make()

# remove debug include folder
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include/)

# remove debug bin folder
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/bin/)

# remove bin folder
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin/)

vcpkg_copy_pdbs()

# remove debug share folder
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share/)

# remove share folder
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/COPYRIGHT DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
