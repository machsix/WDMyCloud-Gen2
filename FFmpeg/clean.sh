#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

#remove links
files="ffmpeg ffprobe qt-faststart"
for f in ${files}; do
  rm -f /usr/sbin/$f
done

APKG_MODULE="FFmpeg"
WEBPATH="/var/www/${APKG_MODULE}"

#remove web
rm -rf $WEBPATH
