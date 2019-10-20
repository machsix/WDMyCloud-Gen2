#!/bin/bash

unset CFLAGS
unset LDFLAGS
unset LIBS

source ../xcp.sh

xbuild()
{
	CFLAGS="$CFLAGS -DALPHA_CUSTOMIZE" make
}

xinstall()
{
   ${CROSS_COMPILE}strip -s busybox
   xcp busybox ${ROOTDIR}/ramdisk/${PROJECT_NAME}/bin
}

xclean()
{
   make clean
}

if [ "$1" = "build" ]; then
   xbuild
elif [ "$1" = "install" ]; then
   xinstall
elif [ "$1" = "clean" ]; then
   xclean
else
   echo "Usage : xbuild.sh build or xbuild.sh install or xbuild.sh clean"
fi
