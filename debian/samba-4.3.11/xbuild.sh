#!/bin/bash

source ../xcp.sh
MY_PREFIX=$PWD/../_xinstall/${PROJECT_NAME}
export MY_PREFIX=$SYS_ROOT   
export TARGET_PREFIX=/usr    #prefix on target machine
export INSTALL_PREFIX=${MY_PREFIX}${TARGET_PREFIX}
export DEB_HOST_MULTIARCH=arm-linux-gnueabihf
unset CFLAGS
unset LDFLAGS
unset LIBS

#Detect build machine ARCH to use prebuilt binaries
MYARCH=`getconf LONG_BIT`
if [ ! -z "$MYARCH" ] && [ "$MYARCH" == "64" ]; then MYARCH=64;else MYARCH=32;fi
	
export TOOLCHAIN_PATH="$PWD/../../bin"
	

xshare()
{
	#Samba's bug , fix it by myself. 
	if [ -f "wscript_configure_system_mitkrb5" ]; then
		sed -i "s/\(msg=.\+WRFILE\):\(-keytab\)/\1\2/" wscript_configure_system_mitkrb5
	fi

	#asn1_compile and compile_et path
	export USING_SYSTEM_ASN1_COMPILE=1 
	export ASN1_COMPILE="`pwd`/asn1/asn1_compile"
	export USING_SYSTEM_COMPILE_ET=1
	export COMPILE_ET="`pwd`/asn1/compile_et"

        # Performance 
	CFLAGS="${CFLAGS} -O3 -pipe -march=armv7-a -mtune=cortex-a9 -mfpu=neon -fno-caller-saves"
        # Enable patch by WD
	CFLAGS="${CFLAGS} -DMAX_DEBUG_LEVEL=10  -D__location__=\"\" -DCONFIG_COMCERTO_SMB_SPLICE"
	CFLAGS="${CFLAGS} -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64"
        INCLUDEPY="${SYS_ROOT}/usr/include/python"
        export CFLAGS="${CFLAGS} -I$INCLUDEPY"
	
        export LDFLAGS="${LDFLAGS} -Wl,--gc-sections"
        export python_LDFLAGS="-L${LIBPL} -lpython2.7"  #overide LDFLAGS of python

	CACHE=armv7

	#Fix --with-modulesdir issue
	MODULESDIR_LINE=`grep -rnI "\#'MODULESDIR'    : 'bin/modules'" dynconfig/wscript`
	if [ -z "$MODULESDIR_LINE" ] ; then
		sed -i "s/'MODULESDIR'    \: 'bin\/modules'/\#'MODULESDIR'    \: 'bin\/modules'/g" dynconfig/wscript
	fi
}

xconf ()
{
        xshare
 	#get from https://sources.debian.org/src/samba/2:4.11.0+dfsg-10/debian/rules/
	./buildtools/bin/waf configure \
		--prefix=$TARGET_PREFIX \
		--enable-fhs \
		--sysconfdir=/etc \
                --localstatedir=/var \
		--libexecdir=/usr/lib/${DEB_HOST_MULTIARCH} \
		--with-privatedir=/var/lib/samba/private \
		--with-piddir=/var/run/samba \
		--with-pammodulesdir=/lib/${DEB_HOST_MULTIARCH}/security \
		--without-pam \
		--without-dmapi \
		--disable-gnutls \
		--without-relro \
		--without-acl-support \
		--without-quotas \
		--with-syslog \
		--with-utmp \
		--without-winbind \
		--with-automount \
		--without-ldap \
		--with-dnsupdate \
		--libdir=/usr/lib/${DEB_HOST_MULTIARCH} \
		--with-modulesdir=/usr/lib/${DEB_HOST_MULTIARCH}/samba \
		--datadir=/usr/share \
		--with-lockdir=/var/run/samba \
		--with-statedir=/var/lib/samba \
		--with-cachedir=/var/cache/samba \
		--enable-avahi \
		--disable-cups \
		--disable-rpath \
		--disable-rpath-install \
		--disable-iprint \
		--hostcc=gcc \
		--cross-compile \
		--target=${TARGET_HOST} \
		--host=${TARGET_HOST} \
		--cross-answers=${CACHE}-cache.txt \
                --without-ad-dc \
		--without-ads \
                --with-systemd \
		--with-logfilebase=/var/log/samba \
		--with-configdir=/etc/samba \
		--with-cluster-support \
		--disable-gnutls \
		--without-pie \
		--nonshared-binary=nmbd/nmbd,smbd/smbd,vfs_catia,vfs_fruit,vfs_streams_xattr,smbpasswd \
		--bundled-libraries="!asn1_compile,!compile_et" \
		--with-static-modules=nmbd/nmbd,smbd/smbd,vfs_catia,vfs_fruit,vfs_streams_xattr,smbpasswd 
}

xbuild () {
                xshare
		#make clean
                make -j`nproc`
   #             exit 0
		make bin/smbd -j`nproc`
		make bin/nmbd -j`nproc`
		make bin/vfs_catia
		make bin/vfs_fruit
		make bin/vfs_streams_xattr
}

xinstall()
{
                INSTALL_DIR=`realpath $1`
                acp='cp -fL'
                mkdir -p ${INSTALL_DIR}/usr/sbin
		$acp bin/smbd ${INSTALL_DIR}/usr/sbin/
		$acp bin/nmbd ${INSTALL_DIR}/usr/sbin/
               
                mkdir -p ${INSTALL_DIR}/usr/lib/${DEB_HOST_MULTIARCH}/samba
                solib='libkrb5-samba4.so.26 libkrb5samba-samba4.so'
                for i in $solib; do
                    $acp bin/shared/private/$i ${INSTALL_DIR}/usr/lib/${DEB_HOST_MULTIARCH}/samba/
                done 
}

xclean()
{
   make clean
}

xmake()
{
	make V=1
}

if [ "$1" = "build" ]; then
   xbuild
elif [ "$1" = "make" ]; then
   xmake
elif [ "$1" = "conf" ]; then
   xconf
elif [ "$1" = "install" ]; then
   xinstall ${1:-temp}
elif [ "$1" = "clean" ]; then
   xclean
else
   echo "Usage : [xbuild.sh build] or [xbuild.sh install] or [xbuild.sh clean]"
fi

