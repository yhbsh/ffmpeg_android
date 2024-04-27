#!/bin/bash

set -xe

TARGET_ARCH="aarch64"
ANDROID_API_LEVEL=34
ANDROID_NDK_VERSION=26.3.11579264
ANDROID_NDK_PATH="$ANDROID_HOME/ndk/$ANDROID_NDK_VERSION"
SYSROOT="$ANDROID_NDK_PATH/toolchains/llvm/prebuilt/darwin-x86_64/sysroot"

LLVM_AR="$ANDROID_NDK_PATH/toolchains/llvm/prebuilt/darwin-x86_64/bin/llvm-ar"
LLVM_NM="$ANDROID_NDK_PATH/toolchains/llvm/prebuilt/darwin-x86_64/bin/llvm-nm"
LLVM_RANLIB="$ANDROID_NDK_PATH/toolchains/llvm/prebuilt/darwin-x86_64/bin/llvm-ranlib"
LLVM_STRIP="$ANDROID_NDK_PATH/toolchains/llvm/prebuilt/darwin-x86_64/bin/llvm-strip"

CLANG="$ANDROID_NDK_PATH/toolchains/llvm/prebuilt/darwin-x86_64/bin/$TARGET_ARCH-linux-android${ANDROID_API_LEVEL}-clang"
CLANGXX="$ANDROID_NDK_PATH/toolchains/llvm/prebuilt/darwin-x86_64/bin/$TARGET_ARCH-linux-android${ANDROID_API_LEVEL}-clang++"


FFMPEG_SOURCE_DIR="$PWD/ffmpeg"
FFMPEG_BUILD_DIR="$PWD/ffmpeg-android-$TARGET_ARCH-$ANDROID_API_LEVEL"

cd $FFMPEG_SOURCE_DIR
./configure \
  --target-os=android \
  --arch=$TARGET_ARCH \
  --enable-cross-compile \
  --cross-prefix="$ANDROID_NDK_PATH/toolchains/llvm/prebuilt/darwin-x86_64/bin/$TARGET_ARCH-linux-android${ANDROID_API_LEVEL}-" \
  --cc="$CLANG" \
  --cxx="$CLANGXX" \
  --sysroot="$SYSROOT" \
  --prefix="$FFMPEG_BUILD_DIR" \
  --extra-cflags="-static -Os -fPIC -march=armv8-a" \
  --extra-ldflags="-L$SYSROOT/usr/lib/$TARGET_ARCH-linux-android/$ANDROID_API_LEVEL -lc" \
  --disable-everything \
  --enable-avcodec \
  --enable-avformat \
  --enable-avutil \
  --enable-swscale \
  --enable-swresample \
  --enable-static \
  --enable-mediacodec \
  --enable-jni \
  --disable-shared \
  --disable-debug \
  --disable-ffplay \
  --disable-ffprobe \
  --disable-doc \
  --disable-symver \
  --enable-gpl \
  --ar="$LLVM_AR" \
  --nm="$LLVM_NM" \
  --ranlib="$LLVM_RANLIB" \
  --strip="$LLVM_STRIP"

make -j
make install -j
