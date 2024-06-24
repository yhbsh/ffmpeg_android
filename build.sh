#!/bin/bash

set -xe

TARGET_ARCH="aarch64"
API_LEVEL="34"
NDK_VERSION="26.3.11579264"

SDK_ROOT="$HOME/Library/Android/sdk"
NDK_ROOT="$SDK_ROOT/ndk/$NDK_VERSION"
TOOLCHAINS="$NDK_ROOT/toolchains/llvm/prebuilt/darwin-x86_64"
SYSROOT="$TOOLCHAINS/sysroot"

LLVM_AR="$TOOLCHAINS/bin/llvm-ar"
LLVM_NM="$TOOLCHAINS/bin/llvm-nm"
LLVM_RANLIB="$TOOLCHAINS/bin/llvm-ranlib"
LLVM_STRIP="$TOOLCHAINS/bin/llvm-strip"

CROSS_PREFIX="$TOOLCHAINS/bin/$TARGET_ARCH-linux-android"
CC="${CROSS_PREFIX}${API_LEVEL}-clang"
CXX="${CROSS_PREFIX}${API_LEVEL}-clang++"

FFMPEG_SOURCE_DIR="$PWD/ffmpeg-7.0.1"
FFMPEG_BUILD_DIR="$PWD/ffmpeg-android-$TARGET_ARCH-$API_LEVEL"

mkdir -p "$FFMPEG_BUILD_DIR"

cd "$FFMPEG_SOURCE_DIR"
./configure                                                                                                           \
    --prefix="$FFMPEG_BUILD_DIR"                                                                                      \
    --enable-cross-compile                                                                                            \
    --cross-prefix="$CROSS_PREFIX"                                                                                    \
    --target-os=android                                                                                               \
    --arch="$TARGET_ARCH"                                                                                             \
    --sysroot="$SYSROOT"                                                                                              \
    --stdc=c11                                                                                                        \
    --cc="$CC"                                                                                                        \
    --cxx="$CXX"                                                                                                      \
    --ar="$LLVM_AR"                                                                                                   \
    --nm="$LLVM_NM"                                                                                                   \
    --ranlib="$LLVM_RANLIB"                                                                                           \
    --strip="$LLVM_STRIP"                                                                                             \
    --pkg-config=pkg-config                                                                                           \
    --disable-armv5te                                                                                                 \
    --disable-armv6                                                                                                   \
    --disable-armv6t2                                                                                                 \
    --enable-pic                                                                                                      \
    --enable-static                                                                                                   \
    --enable-small                                                                                                    \
    --enable-lto                                                                                                      \
    --disable-autodetect                                                                                              \
    --disable-shared                                                                                                  \
    --disable-debug                                                                                                   \
    --disable-programs                                                                                                \
    --disable-logging                                                                                                 \
    --disable-doc                                                                                                     \
    --disable-everything                                                                                              \
    --disable-network                                                                                                 \
    --disable-zlib                                                                                                    \
    --disable-avfilter                                                                                                \
    --disable-swscale                                                                                                 \
    --disable-swresample                                                                                              \
    --disable-decoders                                                                                                \
    --disable-encoders                                                                                                \
    --disable-bsfs                                                                                                    \
    --disable-muxers                                                                                                  \
    --disable-demuxers                                                                                                \
    --disable-parsers                                                                                                 \
    --disable-hwaccels                                                                                                \
    --disable-hwaccels                                                                                                \
    --disable-protocols                                                                                               \
    --disable-indevs                                                                                                  \
    --disable-outdevs                                                                                                 \
    --enable-mediacodec                                                                                               \
    --enable-jni                                                                                                      \
    --enable-protocol='file,pipe'                                                                                     \
    --enable-demuxer='mov'                                                                                            \
    --enable-parser='aac,h264'                                                                                        \
    --enable-decoder='aac,h264,h264_mediacodec'                                                                       \
    --enable-indev='android_camera'                                                                                   \
    --extra-cflags="-Os -fPIC -ffunction-sections -fdata-sections -fno-unwind-tables -fno-asynchronous-unwind-tables" \
    --extra-ldflags="-Wl,--gc-sections"                                                                               \

read -p "Compile FFmpeg? (y/N): " confirm
if [[ $confirm != [yY] ]]; then
  echo "Compilation aborted."
  exit 1
fi

make V=1 install

echo "FFmpeg compilation completed successfully."
