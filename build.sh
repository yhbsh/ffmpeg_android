#!/bin/bash

set -exuo pipefail

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

FFMPEG_SOURCE_DIR="$PWD/ffmpeg"
FFMPEG_BUILD_DIR="$PWD/ffmpeg-android-$TARGET_ARCH-$API_LEVEL"

mkdir -p "$FFMPEG_BUILD_DIR"

cd "$FFMPEG_SOURCE_DIR"
./configure \
  --prefix="$FFMPEG_BUILD_DIR" \
  --target-os=android \
  --arch="$TARGET_ARCH" \
  --cross-prefix="$CROSS_PREFIX" \
  --sysroot="$SYSROOT" \
  --cc="$CC" \
  --cxx="$CXX" \
  --ar="$LLVM_AR" \
  --nm="$LLVM_NM" \
  --ranlib="$LLVM_RANLIB" \
  --strip="$LLVM_STRIP" \
  --pkg-config="pkg-config" \
  --disable-debug \
  --disable-shared \
  --disable-asm \
  --enable-pic \
  --enable-static \
  --enable-cross-compile \
  --enable-mediacodec \
  --enable-jni \
  --enable-neon \
  --enable-indev=android_camera \
  --host-cflags="-fPIC" \
  --extra-cflags="-fPIC" \
  --host-ldflags="-fPIC" \
  --extra-ldflags="-fPIC"

read -p "Compile FFmpeg? (y/N): " confirm
if [[ $confirm != [yY] ]]; then
  echo "Compilation aborted."
  exit 1
fi

make clean
make install -j

echo "FFmpeg compilation completed successfully."
