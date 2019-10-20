#!/bin/sh

build()
{
	if [ -z "$ARCH" ] ; then
		echo "do \"export ARCH=arm\" first."
		exit 1
	fi
	RET=1
	PREV_CROSS_COMPILE=$CROSS_COMPILE
	PREV_PATH=$PATH

	export CROSS_COMPILE=arm-marvell-linux-gnueabi-
	# export PATH=/opt_gccarm/armv7-marvell-linux-gnueabi-softfp_i686_64K_Dev_20131002/bin:/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
	export KBUILD_BUILD_USER=machsix
	export KBUILD_BUILD_HOST=Mars
	export BASEVERSION=2014T20p4
	# export BUILDNO=git$(git rev-parse --verify --short HEAD)
	rm arch/arm/boot/zImage
	mv .config defconfig
	make mrproper
	mv defconfig .config
#	KCFLAGS="-DALPHA_CUSTOMIZE" make zImage
	KCFLAGS="-DALPHA_CUSTOMIZE"
	
	make -j`nproc` zImage
	
	make -j`nproc` dtbs
	
	cat arch/arm/boot/zImage arch/arm/boot/dts/armada-375-db.dtb > arch/arm/boot/zImage_dtb
	
	rm arch/arm/boot/zImage
	
	mv arch/arm/boot/zImage_dtb arch/arm/boot/zImage
	
	./scripts/mkuboot.sh -A arm -O linux -T kernel -C none -a 0x00008000 -e 0x00008000 -n 'Linux-375' -d arch/arm/boot/zImage arch/arm/boot/uImage
	
	if [ $? = 0 ] ; then
		KCFLAGS="-DALPHA_CUSTOMIZE" make modules
		if [ $? = 0 ] ; then
			RET=0
		fi
	fi

	# netatop
	export KERNELDIR=`pwd`
	make clean -C ../netatop-0.5
	make all -C ../netatop-0.5 || exit 1

	export CROSS_COMPILE=$PREV_CROSS_COMPILE
	export PATH=$PREV_PATH

	exit $RET
}

install()
{
	cp -avf arch/arm/boot/uImage ${ROOTDIR}/merge/${PROJECT_NAME}/

	if [ -n "${ROOT_FS}" ] ; then
		# for iSCSI Target
		cp -avf \
			./drivers/target/iscsi/iscsi_target_mod.ko \
			./drivers/target/target_core_mod.ko \
			./drivers/target/target_core_file.ko \
			./drivers/target/target_core_iblock.ko \
			${ROOT_FS}/driver/

		# for Virtual Volume
		cp -avf \
			./drivers/scsi/scsi_transport_iscsi.ko \
			./drivers/scsi/iscsi_tcp.ko \
			./drivers/scsi/libiscsi_tcp.ko \
			./drivers/scsi/libiscsi.ko \
			${ROOT_FS}/driver/

		cp -avf net/ipv4/tunnel4.ko              ${ROOT_FS}/driver/
		cp -avf net/ipv4/ipip.ko                 ${ROOT_FS}/driver/
		cp -avf drivers/net/tun.ko               ${ROOT_FS}/driver/
		
		mkdir -p ${MODULE_DIR}/apkg/addons/${PROJECT_NAME}/VPN/lib/modules
		cp -avf drivers/net/ppp/bsd_comp.ko      ${MODULE_DIR}/apkg/addons/${PROJECT_NAME}/VPN/lib/modules
		cp -avf drivers/net/ppp/ppp_async.ko     ${MODULE_DIR}/apkg/addons/${PROJECT_NAME}/VPN/lib/modules
		cp -avf drivers/net/ppp/ppp_deflate.ko   ${MODULE_DIR}/apkg/addons/${PROJECT_NAME}/VPN/lib/modules
		cp -avf drivers/net/ppp/ppp_generic.ko   ${MODULE_DIR}/apkg/addons/${PROJECT_NAME}/VPN/lib/modules
		cp -avf drivers/net/ppp/ppp_mppe.ko      ${MODULE_DIR}/apkg/addons/${PROJECT_NAME}/VPN/lib/modules
		cp -avf drivers/net/ppp/ppp_synctty.ko   ${MODULE_DIR}/apkg/addons/${PROJECT_NAME}/VPN/lib/modules
		cp -avf drivers/net/ppp/pppoe.ko         ${MODULE_DIR}/apkg/addons/${PROJECT_NAME}/VPN/lib/modules
		cp -avf drivers/net/ppp/pppox.ko         ${MODULE_DIR}/apkg/addons/${PROJECT_NAME}/VPN/lib/modules
		cp -avf drivers/net/slip/slhc.ko         ${MODULE_DIR}/apkg/addons/${PROJECT_NAME}/VPN/lib/modules
		cp -avf lib/crc-ccitt.ko                 ${MODULE_DIR}/apkg/addons/${PROJECT_NAME}/VPN/lib/modules

		# netatop
		cp -avf ../netatop-0.5/module/netatop.ko ${ROOT_FS}/driver/

		# iptable - iptables, netfilter, recent and log module - for ssh brute force protection
		cp -avf \
			net/netfilter/x_tables.ko \
			net/netfilter/nf_conntrack.ko \
			net/netfilter/xt_conntrack.ko \
			net/netfilter/xt_tcpudp.ko \
			net/netfilter/xt_LOG.ko \
			net/netfilter/xt_limit.ko \
			net/netfilter/xt_recent.ko \
			net/netfilter/xt_state.ko \
			net/netfilter/xt_tcpmss.ko \
			net/ipv4/netfilter/ip_tables.ko \
			net/ipv4/netfilter/iptable_filter.ko \
			net/ipv4/netfilter/nf_defrag_ipv4.ko \
			net/ipv4/netfilter/nf_conntrack_ipv4.ko \
			${ROOT_FS}/driver/

	fi
}

clean()
{
	make clean
}

if [ "$1" = "build" ]; then
	build
elif [ "$1" = "install" ]; then
	install
elif [ "$1" = "clean" ]; then
	clean
else
	echo "Usage : $0 build or $0 install or $0 clean"
fi
