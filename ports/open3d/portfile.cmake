vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO intel-isl/Open3D
    REF v0.12.0
    SHA512 dc4724284c879da100c83ff360d54af9bc5a315fb68d94fcb81e36790e16c580c99a47b6192ae8271202dcf30ce41942afb64e8ba9ede39e057b4b6d8c9f549d
    HEAD_REF master
    PATCHES
        0001-use-external-libraries.patch
        0002-fix-eigen-3-3.patch # taken from https://github.com/intel-isl/Open3D/pull/2885
)

string(COMPARE EQUAL "${VCPKG_CRT_LINKAGE}" "static" STATIC_WINDOWS_RUNTIME)

vcpkg_find_acquire_program(PYTHON3)
get_filename_component(PYTHON3_DIR "${PYTHON3}" DIRECTORY)
vcpkg_add_to_path("${PYTHON3_DIR}")


vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DWITH_OPENMP=OFF
        -DWITH_FAISS=OFF
        -DVCPKG_CURRENT_INSTALLED_DIR=${CURRENT_INSTALLED_DIR}/tools
        -DBUILD_CPP_EXAMPLES=OFF
        -DBUILD_UNIT_TESTS=OFF
        -DBUILD_BENCHMARKS=OFF
        -DBUILD_GUI=OFF
        -DBUILD_RPC_INTERFACE=OFF
        -DUSE_SYSTEM_EIGEN3=ON
        -DUSE_SYSTEM_FLANN=ON
        -DUSE_SYSTEM_GLEW=ON
        -DUSE_SYSTEM_GLFW=ON
        -DUSE_SYSTEM_JPEG=ON
        -DUSE_SYSTEM_LIBLZF=OFF
        -DUSE_SYSTEM_PNG=OFF
        -DUSE_SYSTEM_TINYGLTF=ON
        -DUSE_SYSTEM_TINYOBJLOADER=ON
        -DUSE_SYSTEM_QHULL=ON
        -DUSE_SYSTEM_FMT=ON
        -DUSE_SYSTEM_PYBIND11=ON
        -DUSE_SYSTEM_GOOGLETEST=ON
        -DUSE_SYSTEM_IMGUI=ON
        -DBUILD_PYTHON_MODULE=OFF
        -DBUILD_LIBREALSENSE=OFF
        -DBUILD_AZURE_KINECT=OFF
        -DBUILD_FILAMENT_FROM_SOURCE=OFF
        -DSTATIC_WINDOWS_RUNTIME=${STATIC_WINDOWS_RUNTIME}
        -DBUILD_CUDA_MODULE=OFF
        -DBUILD_TENSORFLOW_OPS=OFF
        -DGLIBCXX_USE_CXX11_ABI=ON
        -DDEVELOPER_BUILD=OFF
        -DPYTHON_EXECUTABLE=${PYTHON3}
)

# we have to build this first otherwise install fails
vcpkg_cmake_build(TARGET Open3D)
vcpkg_cmake_install()

if(VCPKG_TARGET_IS_WINDOWS)
    vcpkg_cmake_config_fixup(CONFIG_PATH CMake)
else()
    vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/Open3D)
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/include/open3d/t/io/file_format")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/include/open3d/ml/tensorflow/tf_neighbors")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/include/open3d/ml/tensorflow/tf_subsampling")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/include/open3d/visualization/gui/Resources")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/include/open3d/visualization/gui/Materials")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/include/open3d/visualization/shader/glsl")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/include/open3d/io/file_format")

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
