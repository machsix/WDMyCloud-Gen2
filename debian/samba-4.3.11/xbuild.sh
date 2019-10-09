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

[ -f ./source3/smbd/sgio.c ] && mv ./source3/smbd/sgio.c ./source3/smbd/sgio.c.bak
[ -f ./source3/smbd/sgio.h ] && mv ./source3/smbd/sgio.h ./source3/smbd/sgio.h.bak
sed -i '/smbd\/sgio.c/d' ./source3/wscript_build

xshare()
{
	#Samba's bug , fix it by myself.
	if [ -f "wscript_configure_system_mitkrb5" ]; then
		sed -i "s/\(msg=.\+WRFILE\):\(-keytab\)/\1\2/" wscript_configure_system_mitkrb5
	fi

	#asn1_compile and compile_et path
	export PATH="$PATH:${PWD}/libexec/${MYARCH}"

	CFLAGS="${CFLAGS} -O3 -pipe -march=armv7-a -mtune=cortex-a9 -mfpu=neon -fno-caller-saves"
	CFLAGS="${CFLAGS} -DMAX_DEBUG_LEVEL=10  -D__location__=\"\" -DCONFIG_COMCERTO_SMB_SPLICE -DCONFIG_SMB2_MODALITY -DCONFIG_AAPL_F_FULLSYNC -DCONFIG_TM_LIMIT"
	export CFLAGS="${CFLAGS} -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64"

        LDFLAGS="${LDFLAGS} -Wl,--gc-sections"
	export LDFLAGS="${LDFLAGS} ${LIBS}"
        echo $CFLAGS
        echo $LDFLAGS

  	# Use LIBPL/INCLUDEPY to save avoid warnings
	export LIBPL="${SYS_ROOT}/usr/lib"
        export INCLUDEPY="${SYS_ROOT}/usr/include/python"
        export CFLAGS="-I$INCLUDEPY"
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
		--with-pam \
		--with-syslog \
		--with-utmp \
		--with-winbind \
		--with-shared-modules=idmap_rid,idmap_adex,idmap_hash,idmap_tdb2,vfs_dfs_samba4,auth_samba4 \
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
		--with-pam_smbpass \
 		--with-systemd \
		--without-ad-dc \
		--without-ads \
		--with-logfilebase=/var/log/samba \
		--with-configdir=/etc/samba \
		--with-cluster-support \
		--without-dmapi \
		--disable-gnutls \
		--without-relro \
		--without-acl-support \
		--without-quotas \
		--without-pie \
		--without-relro \
		--nonshared-binary=nmbd/nmbd,smbd/smbd,vfs_catia,vfs_fruit,vfs_streams_xattr \
		--bundled-libraries="!asn1_compile,!compile_et" \
		--builtin-libraries=replace,ccan \
		--with-static-modules=nmbd/nmbd,smbd/smbd,vfs_catia,vfs_fruit,vfs_streams_xattr
}

xbuild () {
                xshare
		#make clean
                #make -j`nproc`
		make bin/smbd -j`nproc`
		make bin/nmbd -j`nproc`
		make bin/vfs_catia
		make bin/vfs_fruit
		make bin/vfs_streams_xattr
}

xinstall()
{
		mkdir -p ${ROOT_FS}/lib/samba ${ROOT_FS}/lib/vfs ${ROOT_FS}/lib/security
		cp -vf bin/shared/* ${ROOT_FS}/lib/
		cp -vf bin/shared/private/* ${ROOT_FS}/lib/
		cp -vf bin/modules/vfs/*.so ${ROOT_FS}/lib/vfs/
		xcp bin/shared/pam_winbind.so ${ROOT_FS}/lib/security/pam_winbind.so
		xcp bin/smbd ${ROOT_FS}/bin/smbd
		xcp bin/nmbd ${ROOT_FS}/bin/nmbd
		xcp bin/smbpasswd ${ROOT_FS}/bin/smbpasswd
		xcp bin/smbclient ${ROOT_FS}/bin/smbclient
		xcp bin/nmblookup ${ROOT_FS}/bin/nmblookup
		xcp bin/wbinfo ${ROOT_FS}/bin/wbinfo
		xcp bin/testparm ${ROOT_FS}/bin/testparm
		xcp bin/winbindd ${ROOT_FS}/bin/winbindd
		xcp bin/net ${ROOT_FS}/bin/net
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
   xinstall
elif [ "$1" = "clean" ]; then
   xclean
else
   echo "Usage : [xbuild.sh build] or [xbuild.sh install] or [xbuild.sh clean]"
fi

