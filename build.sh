#!/bin/bash

ARCH="aarch64"
NDK="/Users/home/Library/Android/sdk/ndk/21.1.6352462"
TOOLCHAINS="$NDK/toolchains/llvm/prebuilt/darwin-x86_64"
SYSROOT="$TOOLCHAINS/sysroot"

LLVM_AR="$TOOLCHAINS/bin/llvm-ar"
LLVM_NM="$TOOLCHAINS/bin/llvm-nm"
LLVM_RANLIB="$TOOLCHAINS/bin/llvm-ranlib"
LLVM_STRIP="$TOOLCHAINS/bin/llvm-strip"

PREFIX="android/$ARCH"

CROSS_PREFIX="$TOOLCHAINS/bin/aarch64-linux-android"
CC="$TOOLCHAINS/bin/aarch64-linux-android21-clang"
CXX="$TOOLCHAINS/bin/aarch64-linux-android21-clang++"

cd ffmpeg-7.0.1

./configure \
--prefix=$PREFIX \
--enable-cross-compile \
--enable-pic \
--sysroot=$SYSROOT \
--cc=$CC \
--cxx=$CXX \
--nm=$LLVM_NM \
--ar=$LLVM_AR \
--ranlib=$LLVM_RANLIB \
--strip=$LLVM_STRIP \
--arch=$ARCH \
--target-os=android \
--disable-all \
--disable-autodetect \
--disable-asm \
--disable-inline-asm \
--enable-avformat \
--enable-avcodec \
--enable-swscale \
--enable-protocol=http \
--enable-demuxer=mov \
