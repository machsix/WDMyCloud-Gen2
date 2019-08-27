#!/bin/sh
[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg
rm -f /var/www/rclone
rm -f /usr/sbin/rclone
rm -f /usr/local/share/man/man1/rclone.1
