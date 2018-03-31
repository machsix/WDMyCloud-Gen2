#!/bin/sh

INSTALL_DIR=$1

killall aria2c >/dev/null 2>&1
rm -f /var/www/Aria2
rm -rf $INSTALL_DIR
rm -f /usr/sbin/aria2c

smbif -t Aria2
