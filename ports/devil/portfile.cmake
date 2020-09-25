vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO DentonW/DevIL
    REF v1.8.0
    SHA512 4aed5e50a730ece8b1eb6b2f6204374c6fb6f5334cf7c880d84c0f79645ea7c6b5118f57a7868a487510fc59c452f51472b272215d4c852f265f58b5857e17c7
    HEAD_REF master
    PATCHES
        0001_fix-encoding.patch
        0002_fix-missing-mfc-includes.patch
        0003_fix-openexr.patch
        enable-static.patch
)

file(REMOVE ${SOURCE_PATH}/DevIL/src-IL/cmake/FindOpenEXR.cmake)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
    INVERTED_FEATURES
    libpng  IL_NO_PNG
    tiff    IL_NO_TIF
    libjpeg IL_NO_JPG
    openexr IL_NO_EXR
    jasper  IL_NO_JP2
    lcms    IL_NO_LCMS
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}/DevIL
    PREFER_NINJA
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS
         ${FEATURE_OPTIONS}
        -DIL_NO_TIF=${IL_NO_TIF}
        -DIL_NO_JPG=${IL_NO_JPG}
        -DIL_NO_EXR=${IL_NO_EXR}
        -DIL_NO_JP2=${IL_NO_JP2}
        -DIL_NO_MNG=${IL_NO_MNG}
        -DIL_NO_LCMS=${IL_NO_LCMS}
        -DIL_USE_DXTC_NVIDIA=${IL_USE_DXTC_NVIDIA}
        -DIL_USE_DXTC_SQUISH=${IL_USE_DXTC_SQUISH}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
