#!/bin/sh

INSTALL_DIR=$1

# replace shell
sleep 30s
ln -sf /bin/busybox-1.20.2 /bin/ash
ln -sf /bin/busybox-1.20.2 /bin/sh
