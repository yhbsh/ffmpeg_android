#!/bin/bash

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

cd "./ffmpeg-7.0.1"

./configure \
    --prefix="$PWD/../android_build" \
    --enable-cross-compile \
    --cross-prefix="$CROSS_PREFIX" \
    --target-os=android \
    --arch="$TARGET_ARCH" \
    --sysroot="$SYSROOT" \
    --stdc=c11 \
    --cc="$CC" \
    --cxx="$CXX" \
    --ar="$LLVM_AR" \
    --nm="$LLVM_NM" \
    --ranlib="$LLVM_RANLIB" \
    --strip="$LLVM_STRIP" \
    --pkg-config=pkg-config \
    --enable-pic \
    --enable-small \
    --disable-iconv \
    --disable-autodetect \
    --disable-debug \
    --disable-programs \
    --disable-everything \
    --disable-network \
    --enable-demuxer=mov \
    --enable-parser=h264 \
    --enable-decoder=h264 \
