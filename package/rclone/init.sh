#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path=$1

ln -sf $path/web /var/www/rclone
ln -sf $path/sbin/rclone /usr/sbin/rclone
ln -sf $path/man/rclone.1 /usr/local/share/man/man1/rclone.1
command -v mandb >/dev/null 2>&1 && mandb

