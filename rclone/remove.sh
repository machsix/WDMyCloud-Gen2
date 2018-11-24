#!/bin/sh

INSTALL_DIR=$1

sed -i '/export XDG_CONFIG_HOME.*/d' /home/root/.profile

rm -rf $INSTALL_DIR
rm -f /var/www/rclone
rm -f /usr/sbin/rclone
rm -f /usr/local/share/man/man1/rclone.1
