#!/bin/sh

INSTALL_DIR=$1
DEFINES=/usr/local/model/web/pages/function/define.js

rm -f $DEFINES
if [ -e $INSTALL_DIR/define.js.bak ]; then
    cp $INSTALL_DIR/define.js.bak $DEFINES
fi

