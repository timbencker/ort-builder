#!/usr/bin/env bash
set -euf -o pipefail

ONNX_CONFIG="${1:-model.required_operators_and_types.config}"
CMAKE_BUILD_TYPE=MinSizeRel
ARCH=arm64

python onnxruntime/tools/ci_build/build.py \
--build_dir "onnxruntime/build/iOS-${ARCH}" \
--config=${CMAKE_BUILD_TYPE} \
--ios \
--use_xcode \
--build_apple_framework \
--ios_sysroot iphoneos \
--osx_arch ${ARCH} \
--parallel \
--minimal_build \
--apple_deploy_target="14.0" \
--disable_ml_ops --disable_rtti \
--include_ops_by_config "$ONNX_CONFIG" \
--enable_reduced_operator_type_support \
--cmake_extra_defines CMAKE_OSX_ARCHITECTURES="${ARCH}" \
--skip_tests

BUILD_DIR=./onnxruntime/build/iOS-${ARCH}/${CMAKE_BUILD_TYPE}/static_libraries

libtool -static -o "./libs/ios-arm64/libonnxruntime.a" \
"${BUILD_DIR}/libonnx.a" \
"${BUILD_DIR}/libonnxruntime_graph.a" \
"${BUILD_DIR}/libonnx_proto.a" \
"${BUILD_DIR}/libonnxruntime_mlas.a" \
"${BUILD_DIR}/libonnxruntime_optimizer.a" \
"${BUILD_DIR}/libonnxruntime_providers.a" \
"${BUILD_DIR}/libonnxruntime_common.a" \
"${BUILD_DIR}/libonnxruntime_session.a" \
"${BUILD_DIR}/libonnxruntime_flatbuffers.a" \
"${BUILD_DIR}/libonnxruntime_framework.a" \
"${BUILD_DIR}/libonnxruntime_util.a" \
"${BUILD_DIR}/libre2.a" \
"${BUILD_DIR}/libnsync_cpp.a" \
"${BUILD_DIR}/libprotobuf-lite.a" \
"${BUILD_DIR}/libabsl_hash.a" \
"${BUILD_DIR}/libabsl_city.a" \
"${BUILD_DIR}/libabsl_low_level_hash.a" \
"${BUILD_DIR}/libabsl_throw_delegate.a" \
"${BUILD_DIR}/libabsl_raw_hash_set.a" \
"${BUILD_DIR}/libabsl_raw_logging_internal.a"