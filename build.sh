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
YASM="$TOOCHAINS/bin/yasm"

CROSS_PREFIX="$TOOLCHAINS/bin/$TARGET_ARCH-linux-android"
CC="${CROSS_PREFIX}${API_LEVEL}-clang"
CXX="${CROSS_PREFIX}${API_LEVEL}-clang++"
CFLAGS="-fPIC -Wl,-Bsymbolic -Os -fPIE -pie -static -fPIC"
LDFLAGS="-L$SYSROOT/usr/lib/$TARGET_ARCH-linux-android/$API_LEVEL -lc -Wl, --verbose"

FFMPEG_SOURCE_DIR="$PWD/ffmpeg"
FFMPEG_BUILD_DIR="$PWD/ffmpeg-android-$TARGET_ARCH-$API_LEVEL"

cd $FFMPEG_SOURCE_DIR
./configure \
  --cc="$CC" \
  --cxx="$CXX" \
  --arch="$TARGET_ARCH" \
  --target-os=android \
  --yasmexe=$NDK/prebuilt/darwin-x86_64/bin/yasm \
  --prefix="$FFMPEG_BUILD_DIR" \
  --cross-prefix="$CROSS_PREFIX" \
  --sysroot="$SYSROOT" \
  --extra-cflags="$CFLAGS" \
  --extra-ldflags="$LDFLAGS" \
  --enable-pic \
  --enable-cross-compile \
  --enable-neon \
  --enable-asm \
  --enable-static \
  --enable-inline-asm \
  --disable-shared \
  --disable-programs \
  --disable-iconv \
  --disable-debug \
  --disable-symver \
  --disable-doc \
  --disable-avx \
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
