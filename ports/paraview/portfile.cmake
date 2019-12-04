# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT_DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   CURRENT_INSTALLED_DIR     = ${VCPKG_ROOT_DIR}\installed\${TRIPLET}
#   DOWNLOADS                 = ${VCPKG_ROOT_DIR}\downloads
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#   VCPKG_TOOLCHAIN           = ON OFF
#   TRIPLET_SYSTEM_ARCH       = arm x86 x64
#   BUILD_ARCH                = "Win32" "x64" "ARM"
#   MSBUILD_PLATFORM          = "Win32"/"x64"/${TRIPLET_SYSTEM_ARCH}
#   DEBUG_CONFIG              = "Debug Static" "Debug Dll"
#   RELEASE_CONFIG            = "Release Static"" "Release DLL"
#   VCPKG_TARGET_IS_WINDOWS
#   VCPKG_TARGET_IS_UWP
#   VCPKG_TARGET_IS_LINUX
#   VCPKG_TARGET_IS_OSX
#   VCPKG_TARGET_IS_FREEBSD
#   VCPKG_TARGET_IS_ANDROID
#   VCPKG_TARGET_EXECUTABLE_SUFFIX
#   VCPKG_TARGET_STATIC_LIBRARY_SUFFIX
#   VCPKG_TARGET_SHARED_LIBRARY_SUFFIX
#
# 	See additional helpful variables in /docs/maintainers/vcpkg_common_definitions.md 

# # Specifies if the port install should fail immediately given a condition
# vcpkg_fail_port_install(MESSAGE "paraview currently only supports Linux and Mac platforms" ON_TARGET "Windows")

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Kitware/ParaView
    REF 587b66e78632f6d30443c990141c4a99dec74f0a # v5.6.3
    SHA512 1a693074830c5ca0e95a628f7c55ca93ddc03ff832715e893e5cf69a1097c1e3afe794d264f9bcb36632ca487d78fd2961a3eb5358b5c2601387d75befbb8138
    HEAD_REF master
    PATCHES
        FindPythonModule.patch
)

#file(REMOVE_RECURSE ${SOURCE_PATH}/ThirdPary/protobuf/vtkprotobuf)
file(REMOVE_RECURSE "${SOURCE_PATH}/ThirdParty/QtTesting")
# # Check if one or more features are a part of a package installation.
# # See /docs/maintainers/vcpkg_check_features.md for more details
# vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
#   FEATURES # <- Keyword FEATURES is required because INVERTED_FEATURES are being used
#     tbb   WITH_TBB
#   INVERTED_FEATURES
#     tbb   ROCKSDB_IGNORE_PACKAGE_TBB
# )

vcpkg_find_acquire_program(PYTHON3)
get_filename_component(PYTHON3_EXE_PATH ${PYTHON3} DIRECTORY)
vcpkg_add_to_path(PREPEND "${PYTHON3_EXE_PATH}")
    
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
     OPTIONS 
        -DCMAKE_MODULE_PATH:PATH=${CURRENT_INSTALLED_DIR}/share
        -DPARAVIEW_USE_EXTERNAL:BOOL=ON
        -DVTK_MODULES_DIR:PATH=${CURRENT_INSTALLED_DIR}/share/vtk/Modules
        -DVTK_INSTALL_PACKAGE_DIR:PATH=
        -DVTK_MODULES_DIR:PATH=${CURRENT_INSTALLED_DIR}/share/vtk/Modules
        -DUSE_EXTERNAL_VTK:BOOL=ON
        -DVTK_USE_SYSTEM_PROTOBUF:BOOL=ON
        -DVTK_USE_SYSTEM_CGNS:BOOL=ON
        -DPARAVIEW_USE_VTKM:BOOL=OFF # VTK-m port is missing
        -DVTK_MODULE_ENABLE_vtkqttesting:BOOL=OFF
        -DVTK_MODULE_ENABLE_vtkIOParallelExodus:BOOL=OFF
        -DVTK_MODULE_ENABLE_vtkRenderingParallel:BOOL=OFF
        -DVTK_ENABLE_KITS:BOOL=ON
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

#TODO. Patch .cmake from FindPythonModules in CMakeLists.txt away
#VTK_MODULE_USE_EXTERNAL_<name>

vcpkg_install_cmake()

# # Moves all .cmake files from /debug/share/paraview/ to /share/paraview/
# # See /docs/maintainers/vcpkg_fixup_cmake_targets.md for more details
# vcpkg_fixup_cmake_targets(CONFIG_PATH cmake TARGET_PATH share/paraview)

# # Handle copyright
# file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/paraview RENAME copyright)

# # Post-build test for cmake libraries
# vcpkg_test_cmake(PACKAGE_NAME paraview)
