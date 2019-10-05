#!/bin/sh

INSTALL_DIR=$1
DEFINES=/usr/local/model/web/pages/function/define.js

if [ -L $DEFINES ]; then
	cp $DEFINES $INSTALL_DIR/define.js.bak
fi

rm -f $DEFINES
ln -sf $INSTALL_DIR/define.js $DEFINES
chmod 444 $INSTALL_DIR/define.js
