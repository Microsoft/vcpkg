
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO pytorch/pytorch
    REF v1.7.1
    SHA512 359e271093e7afd374202f48e40356d195f644f78377a0b88f38627ad7aeabb9201a18c12ff35fb4aaf0d731168e511504445d8b4c08e92eed50264e23d81bae
)

# todo: support USE_FFMPEG, USE_REDIS
vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
  FEATURES
    python3 BUILD_PYTHON
    python3 USE_NUMPY
    opencv3 USE_OPENCV
    tbb     USE_TBB
    opencl  USE_OPENCL
    cuda    USE_CUDA
    cuda    USE_CUDNN
    cuda    USE_NCCL
    cuda    USE_NVRTC
    metal   USE_METAL
    vulkan  USE_VULKAN
    vulkan  USE_VULKAN_WRAPPER
    vulkan  USE_VULKAN_SHADERC_RUNTIME
    vulkan  USE_VULKAN_RELAXED_PRECISION
    nnpack  USE_NNPACK  # todo: check use of `DISABLE_NNPACK_AND_FAMILY`
    xnnpack USE_XNNPACK
    qnnpack USE_QNNPACK
    qnnpack USE_PYTORCH_QNNPACK
)

if("python3" IN_LIST FEATURES)
    # Check the Python version and NumPy is visible.
    cmake_minimum_required(VERSION 3.14)
    find_package(Python 3.6.2 REQUIRED COMPONENTS NumPy)
endif()
if("cuda" IN_LIST FEATURES)
    # todo: Need more detailed review for linkage option usage in the project
    list(APPEND FEATURE_OPTIONS -DUSE_STATIC_CUDNN=OFF -DUSE_STATIC_NCCL=OFF -DUSE_SYSTEM_NCCL=OFF)
endif()

if(CMAKE_CXX_COMPILER_ID MATCHES GNU)
    list(APPEND FEATURE_OPTIONS -DUSE_NATIVE_ARCH=ON)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        ${FEATURE_OPTIONS}
        -DUSE_SYSTEM_LIBS=OFF
        -DINTERN_BUILD_MOBILE=OFF -DBUILD_JNI=OFF
        -DUSE_NUMA=${VCPKG_TARGET_IS_LINUX}
        -DUSE_GFLAGS=ON -DUSE_GLOG=ON -DUSE_LEVELDB=ON -DUSE_LMDB=ON -DBUILD_CUSTOM_PROTOBUF=OFF -DUSE_ZSTD=ON -DUSE_SYSTEM_EIGEN_INSTALL=ON -DUSE_SYSTEM_CPUINFO=ON -DUSE_FBGEMM=ON -DUSE_SYSTEM_FP16=ON
        -DUSE_LITE_PROTO=OFF -DUSE_ROCKSDB=OFF -DUSE_OPENMP=OFF -DUSE_MKLDNN=OFF
        -DUSE_OBSERVERS=OFF 
        -DUSE_DISTRIBUTED=OFF -DUSE_GLOO=OFF # requires 'openmpi', 'gloo[mpi,redis]'
        -DONNX_ML=OFF -DINTERN_DISABLE_ONNX=OFF
    OPTIONS_DEBUG
        -DUSE_ASAN=ON
        -DUSE_TSAN=ON
)
vcpkg_install_cmake()
vcpkg_copy_pdbs()
# vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/pytorch)

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
