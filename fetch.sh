#!/usr/bin/env bash

set -e

if [ ! -d ffmpeg-7.0 ]; then
  wget https://ffmpeg.org/releases/ffmpeg-7.0.tar.xz
  tar fvx ffmpeg-7.0.tar.xz
  rm ffmpeg-7.0.tar.xz
fi

if [ ! -d libiconv-1.17 ]; then
  wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.17.tar.gz
  tar fvx libiconv-1.17.tar.gz
  rm libiconv-1.17.tar.gz
fi

