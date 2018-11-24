#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path_src=$1
path_des=$2

APKG_MODULE="rclone"
APKG_PATH=${path_des}/${APKG_MODULE}

cp -R $path_src $path_des
chown root:root $APKG_PATH/sbin/rclone
chmod 755 $APKG_PATH/sbin/rclone

if [ -f /home/root/.config/rclone/rclone.conf ]; then
  cat /home/root/.config/rclone/rclone.conf > $APKG_PATH/config/rclone/rclone.conf
  rm -rf /home/root/.config/rclone
fi
