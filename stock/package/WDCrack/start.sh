#!/bin/sh

INSTALL_DIR=$1
DEFINES=/usr/local/model/web/pages/function/define.js

rm -f $DEFINES
ln -sf $INSTALL_DIR/define.js $DEFINES
chmod 444 $INSTALL_DIR/define.js