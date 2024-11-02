#!/usr/bin/env bash
set -xe

FFMPEG_VERSION="7.0.1"
FFMPEG_ARCHIVE="ffmpeg-${FFMPEG_VERSION}.tar.xz"
FFMPEG_FOLDER="ffmpeg-${FFMPEG_VERSION}"

if [ ! -f "$FFMPEG_ARCHIVE" ] && [ ! -d "$FFMPEG_FOLDER" ]; then
    curl -s "https://ffmpeg.org/releases/${FFMPEG_ARCHIVE}" --output $FFMPEG_ARCHIVE
    tar fvx "$FFMPEG_ARCHIVE"
    rm "$FFMPEG_ARCHIVE"
fi
