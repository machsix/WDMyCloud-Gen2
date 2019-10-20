#! /bin/sh

unset CFLAGS
unset LDFLAGS
unset LIBS


source ../xcp.sh

xbuild()
{
	./configure --host=${CC%-*} --enable-maintainer-mode  --disable-acl-support
	make clean
	make rsync
	${CC%-*}-strip -s rsync
}


xinstall()
{
	${CC%-*}-strip -s rsync

	xcp rsync ${ROOT_FS}/sbin
}

xclean()
{
	make clean
	rm -rf autom4te.cache/
	git checkout config.h.in configure.sh config.h config.log config.status lib/dummy popt/dummy shconfig zlib/dummy Makefile

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

