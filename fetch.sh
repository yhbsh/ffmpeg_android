#!/usr/bin/env bash

set -e

if [ ! -d ffmpeg-7.0 ]; then
  wget https://ffmpeg.org/releases/ffmpeg-7.0.tar.xz
  tar fvx ffmpeg-7.0.tar.xz
  rm ffmpeg-7.0.tar.xz
fi

