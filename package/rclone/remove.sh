#!/bin/sh

INSTALL_DIR=$1

sed -i '/export XDG_CONFIG_HOME.*/d' /home/root/.profile

rm -rf $INSTALL_DIR
