#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

spath=$1

echo "Link file from : "$spath

files="ffmpeg ffprobe qt-faststart"
for f in ${files}; do
  ln -sf $spath/sbin/$f /usr/sbin/$f
done


APKG_MODULE="ffmpeg"
WEBPATH="/var/www/${APKG_MODULE}"
mkdir -p $WEBPATH
ln -sf $spath/web/* $WEBPATH
