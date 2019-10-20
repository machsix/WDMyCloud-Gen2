#!/bin/sh

INSTALL_DIR=$1

nohup aria2c --conf-path=$INSTALL_DIR/config/aria2.conf > /dev/null 2>&1 &
