
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO pytorch/pytorch
    REF v1.8.1
    SHA512 33f5fe813641bdcdcbf5cde4bf8eb5af7fc6f8b3ab37067b0ec10eebda56cdca0c1b42053448ebdd2ab959adb3e9532646324a72729562f8e253229534b39146
    HEAD_REF master
    # PATCHES
    #     fix-cmake.patch
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
  FEATURES
    opencv3 USE_OPENCV
    tbb     USE_TBB
    leveldb USE_LEVELDB
    opencl  USE_OPENCL
    cuda    USE_CUDA
    cuda    USE_CUDNN
    cuda    USE_NCCL
    cuda    USE_SYSTEM_NCCL
    cuda    USE_NVRTC
    vulkan  USE_VULKAN
    vulkan  USE_VULKAN_WRAPPER
    vulkan  USE_VULKAN_SHADERC_RUNTIME
    vulkan  USE_VULKAN_RELAXED_PRECISION
    nnpack  USE_NNPACK  # todo: check use of `DISABLE_NNPACK_AND_FAMILY`
    xnnpack USE_XNNPACK
    xnnpack USE_SYSTEM_XNNPACK
    qnnpack USE_QNNPACK # todo: check use of `USE_PYTORCH_QNNPACK`
)

vcpkg_find_acquire_program(PYTHON3)

if("cuda" IN_LIST FEATURES)
    # todo: Need more detailed review for linkage option usage in the project
    list(APPEND FEATURE_OPTIONS
        -DUSE_STATIC_CUDNN=OFF
        -DUSE_STATIC_NCCL=OFF
        -DUSE_SYSTEM_NCCL=OFF
    )
endif()

if(CMAKE_CXX_COMPILER_ID MATCHES GNU)
    list(APPEND FEATURE_OPTIONS -DUSE_NATIVE_ARCH=ON)
endif()
if(VCPKG_TARGET_IS_LINUX OR VCPKG_TARGET_IS_OSX)
    list(APPEND FEATURE_OPTIONS -DUSE_TENSORPIPE=ON)
endif()

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        ${FEATURE_OPTIONS}
        -DUSE_SYSTEM_LIBS=OFF # we will configure USE_SYSTEM_ variables manually
        -DUSE_SYSTEM_EIGEN_INSTALL=ON
        -DUSE_SYSTEM_SLEEF=ON
        -DUSE_SYSTEM_FP16=ON
        -DUSE_SYSTEM_PTHREADPOOL=ON
        -DUSE_SYSTEM_PSIMD=ON
        -DUSE_SYSTEM_FXDIV=ON
        -DUSE_SYSTEM_CPUINFO=ON
        -DUSE_SYSTEM_ONNX=ON
        -DINTERN_DISABLE_ONNX=OFF
        -DONNX_ML=ON
        -DBUILD_CUSTOM_PROTOBUF=OFF
        -DBUILD_PYTHON=OFF
        -DPYTHON_EXECUTABLE=${PYTHON3}
        -DBUILD_TEST=OFF
        -DINTERN_BUILD_MOBILE=OFF
        -DBUILD_JNI=OFF
        -DUSE_NNAPI=${VCPKG_TARGET_IS_ANDROID}
        -DUSE_METAL=${VCPKG_TARGET_IS_IOS}
        -DBLAS=Eigen
        -DUSE_GFLAGS=ON
        -DUSE_GLOG=ON
        -DUSE_LMDB=ON
        -DUSE_ZSTD=ON
        -DUSE_FBGEMM=ON
        -DUSE_NUMPY=ON
        -DUSE_LITE_PROTO=OFF
        -DUSE_ROCKSDB=OFF
        -DUSE_OPENMP=OFF
        -DUSE_MKLDNN=OFF
        -DUSE_OBSERVERS=OFF 
        -DUSE_DISTRIBUTED=OFF
        -DUSE_GLOO=OFF # requires 'openmpi', 'gloo[mpi,redis]'
        -DUSE_SYSTEM_GLOO=ON
        -DUSE_FFMPEG=OFF
        -DUSE_REDIS=OFF
        -DUSE_KINETO=OFF
        -DUSE_NUMA=OFF
        -DUSE_PYTORCH_QNNPACK=OFF
    OPTIONS_DEBUG
        -DUSE_TSAN=ON  # Both options are exclusive. Here, we activate thread sanitizer
        -DUSE_ASAN=OFF # because we have related options like TBB and OpenMP
)
vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup()

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
