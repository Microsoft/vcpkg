vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO onnx/optimizer
    REF v0.2.5
    SHA512 be9ba20faf4e82111ecc39dd2b961574dfec91e526f0c4848aaa49bf74f8a14301761717a343b067c2ae2379dd6b0d8d0abf6431590da11e5c46e8954d15bd55
    HEAD_REF master
    PATCHES
        fix-cmakelists.patch
        fix-pybind11.patch
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        pybind11 BUILD_ONNX_PYTHON
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" USE_PROTOBUF_SHARED)
list(APPEND FEATURE_OPTIONS 
    -DONNX_USE_PROTOBUF_SHARED_LIBS=${USE_PROTOBUF_SHARED}
)

vcpkg_check_linkage(ONLY_STATIC_LIBRARY)
vcpkg_find_acquire_program(PYTHON3)

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        ${FEATURE_OPTIONS}
        -DPython_EXECUTABLE=${PYTHON3}
        -DPYTHON_EXECUTABLE=${PYTHON3}
)
if("pybind11" IN_LIST FEATURES)
    # This target is not in install/export
    vcpkg_cmake_build(TARGET onnx_opt_cpp2py_export)
endif()
vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(PACKAGE_NAME ONNXOptimizer CONFIG_PATH lib/cmake/ONNXOptimizer)

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/include/onnx)
file(RENAME ${CURRENT_PACKAGES_DIR}/include/onnxoptimizer 
            ${CURRENT_PACKAGES_DIR}/include/onnx/optimizer
)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include
                    ${CURRENT_PACKAGES_DIR}/debug/share
                    ${CURRENT_PACKAGES_DIR}/include/onnx/optimizer/test
)
