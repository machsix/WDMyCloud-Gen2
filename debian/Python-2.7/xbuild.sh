#!/bin/bash

#unset CFLAGS
#unset LDFLAGS
#unset LIBS

source ../xcp.sh
export MY_PREFIX=$SYS_ROOT   # only for include package, but the file built is in this directory
export TARGET_PREFIX=/usr
export INSTALL_PREFIX=${MY_PREFIX}${TARGET_PREFIX}
#Detect build machine ARCH to use prebuilt binaries
MYARCH=`getconf LONG_BIT`
if [ ! -z "$MYARCH" ] && [ "$MYARCH" == "64" ]; then MYARCH=64;else MYARCH=32;fi

xbuild()
{
	export CFLAGS="${CFLAGS} -I${MY_PREFIX}/include"
	export CPPFLAGS="${CFLAGS} -I${MY_PREFIX}/include"
	export LDFLAGS="${LDFLAGS} -L${MY_PREFIX}/lib"
	export LIBS="${LIBS}"

	./configure --host=${TARGET_HOST} \
                    --build=x86_64 \
				--prefix=${TARGET_PREFIX} \
				--disable-ipv6 \
				--enable-shared \
				ac_cv_file__dev_ptmx=no \
				ac_cv_file__dev_ptc=no \
				ac_cv_have_long_long_format=yes
	sed -i 's/\($(MAKE)\s\+$(PGEN)\)/#\1/' Makefile
	cp -arf libexec/$MYARCH/* .
	make -j`nproc`
	make install DESTDIR=$MY_PREFIX | tee make_install.log
	if [ ! -d ${INSTALL_PREFIX}/include/python ]; then
		mkdir -p ${INSTALL_PREFIX}/include/python
	fi	
	cp ./Include/* ${INSTALL_PREFIX}/include/python
	cp pyconfig.h ${INSTALL_PREFIX}/include/python
}

xinstall()
{
	${CROSS_COMPILE}strip -s libpython2.7.so.1.0
        mkdir -p $ROOT_FS/lib
	xcp libpython2.7.so.1.0 ${ROOT_FS}/lib/
	ln -sf libpython2.7.so.1.0 ${ROOT_FS}/lib/libpython2.7.so
}

xclean()
{
   make clean
   make distclean
}


if [ "$1" = "build" ]; then
   xbuild
elif [ "$1" = "install" ]; then
   xinstall
elif [ "$1" = "clean" ]; then
   xclean
else
   echo "Usage : [xbuild.sh build] or [xbuild.sh install] or [xbuild.sh clean]"
fi
