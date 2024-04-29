#!/bin/bash

set -xe

TARGET_ARCH="aarch64"
API_LEVEL="21"
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
CFLAGS="-O3 -fPIC -march=armv8-a"
LDFLAGS="-L$SYSROOT/usr/lib/$TARGET_ARCH-linux-android/$API_LEVEL -lc -Wl, --verbose"

FFMPEG_SOURCE_DIR="$PWD/ffmpeg-7.0"
FFMPEG_BUILD_DIR="$PWD/ffmpeg-7.0-android-$TARGET_ARCH-$API_LEVEL"

cd $FFMPEG_SOURCE_DIR
./configure \
  --target-os=android \
  --arch="$TARGET_ARCH" \
  --enable-cross-compile \
  --cross-prefix="$CROSS_PREFIX" \
  --cc="$CC" \
  --cxx="$CXX" \
  --sysroot="$SYSROOT" \
  --prefix="$FFMPEG_BUILD_DIR" \
  --extra-cflags="$CFLAGS" \
  --extra-ldflags="$LDFLAGS" \
  --enable-pic \
  --enable-neon \
  --enable-asm \
  --enable-shared \
  --disable-static \
  --disable-programs \
  --disable-iconv \
  --disable-debug \
  --disable-symver \
  --disable-doc \
  --disable-htmlpages \
  --disable-manpages \
  --disable-podpages \
  --disable-txtpages \
  --ar="$LLVM_AR" \
  --nm="$LLVM_NM" \
  --ranlib="$LLVM_RANLIB" \
  --strip="$LLVM_STRIP"

make clean
make -j$(nproc)
make install -j$(nproc)
