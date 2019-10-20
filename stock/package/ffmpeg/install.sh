#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path_src=$1
path_des=$2

APKG_MODULE="ffmpeg"

cp -rf $path_src $path_des

