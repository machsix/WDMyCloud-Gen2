#!/bin/bash

unset CFLAGS
unset LDFLAGS
unset LIBS

source ../xcp.sh

xbuild()
{
	[ -f Makefile ] && make clean
	./configure --host=${CC%-*}
	sed -i -e 's/doc man po tests //g' Makefile
	make
}

xinstall()
{
   bin=`find src -executable`
   for i in $bin; do
     pkg=`basename $i`
     ${CROSS_COMPILE}strip -s src/$pkg
   
     xcp src/$pkg ${ROOT_FS}/bin
   done
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

