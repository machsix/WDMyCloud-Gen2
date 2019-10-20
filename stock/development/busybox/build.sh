#!/bin/bash

set +e

# load toolchain

tar xf busybox-1.20.2.tar.gz

cd busybox-1.20.2

patch -p2 < ../i8n.patch

make clean

cp ../xbuild.sh ./
cp ../busybox.config  .config

chmod +x ./xbuild.sh

./xbuild.sh build

${CROSS_COMPILE}strip -s busybox


