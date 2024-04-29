#!/bin/bash

set -xe

TARGET_ARCH="aarch64"
API_LEVEL="30"
NDK_VERSION="26.3.11579264"

SDK_ROOT="$HOME/Library/Android/sdk"
NDK_ROOT="$SDK_ROOT/ndk/$NDK_VERSION"
TOOLCHAINS="$NDK_ROOT/toolchains/llvm/prebuilt/darwin-x86_64"
SYSROOT="$TOOLCHAINS/sysroot"

LLVM_AR="$TOOLCHAINS/bin/llvm-ar"
LLVM_NM="$TOOLCHAINS/bin/llvm-nm"
LLVM_RANLIB="$TOOLCHAINS/bin/llvm-ranlib"
LLVM_STRIP="$TOOLCHAINS/bin/llvm-strip"

CC="$TOOLCHAINS/bin/$TARGET_ARCH-linux-android${API_LEVEL}-clang"
CXX="$TOOLCHAINS/bin/$TARGET_ARCH-linux-android${API_LEVEL}-clang++"
CFLAGS="-static -Os -fPIC -march=armv8-a -ffunction-sections -fdata-sections"
LDFLAGS="-L$SYSROOT/usr/lib/$TARGET_ARCH-linux-android/$API_LEVEL -lc -Wl,--gc-sections"

CROSS_PREFIX="$TOOLCHAINS/bin/$TARGET_ARCH-linux-android$API_LEVEL-"

FFMPEG_SOURCE_DIR="$PWD/ffmpeg-7.0"
FFMPEG_BUILD_DIR="$PWD/ffmpeg-7.0-android-$TARGET_ARCH-$API_LEVEL"

LIBICONV_SOURCE_DIR="$PWD/libiconv-1.17"
LIBICONV_BUILD_DIR="$PWD/libiconv-1.17-android-$TARGET_ARCH-$API_LEVEL"

cd $LIBICONV_SOURCE_DIR
./configure \
  --host="$TARGET_ARCH-linux-android" \
  --prefix="$LIBICONV_BUILD_DIR" \
  --enable-static \
  --disable-shared \
  --with-sysroot="$SYSROOT" \
  CC="$CC" \
  CXX="$CXX" \
  AR="$LLVM_AR" \
  NM="$LLVM_NM" \
  RANLIB="$LLVM_RANLIB" \
  STRIP="$LLVM_STRIP" \
  CFLAGS="$CFLAGS" \
  LDFLAGS="$LDFLAGS"
make -j$(nproc)
make install -j$(nproc)

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
  --disable-everything \
  --enable-decoder=h264 \
  --enable-decoder=mpeg4 \
  --enable-parser=h264 \
  --enable-parser=mpeg4 \
  --enable-demuxer=mov \
  --enable-demuxer=mpegvideo \
  --enable-protocol=file \
  --enable-avcodec \
  --enable-avformat \
  --enable-avutil \
  --enable-static \
  --disable-shared \
  --disable-debug \
  --disable-doc \
  --disable-symver \
  --enable-gpl \
  --ar="$LLVM_AR" \
  --nm="$LLVM_NM" \
  --ranlib="$LLVM_RANLIB" \
  --strip="$LLVM_STRIP"
make -j$(nproc)
make install -j$(nproc)
