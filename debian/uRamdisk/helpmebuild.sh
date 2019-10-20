#!/bin/sh

DEVICE="armada-375-wdmc-gen2"
CUR_DIR=`pwd`
CUR_DIR_NAME=`basename $CUR_DIR`
BIN_DIR="$CUR_DIR/../$CUR_DIR_NAME-bin"
#CROSS_COMPILE="$CUR_DIR/../cc-armada370-wd-sw64k/bin/arm-marvell-linux-gnueabi-"
CROSS_COMPILE="$CUR_DIR/../cc-armada370/bin/arm-unknown-linux-gnueabi-"
#CROSS_COMPILE="$CUR_DIR/../cc-armada380/bin/arm-unknown-linux-gnueabi-"
ARCH="arm"
MAKE_CMD="make CROSS_COMPILE=$CROSS_COMPILE ARCH=$ARCH"

mkdir -p $BIN_DIR

case "$1" in
	"")
		echo "Use as $0 {menu|image|modules|*make command*}"
		exit 65;;
	"menu")
		$MAKE_CMD menuconfig
		;;
	"uimage")
		$MAKE_CMD zImage
		$MAKE_CMD $DEVICE.dtb
		cat arch/arm/boot/zImage arch/arm/boot/dts/$DEVICE.dtb > arch/arm/boot/zImage_dtb
		mkimage -A arm -O linux -T kernel -C none -a 0x00008000 -e 0x00008000 -n $DEVICE -d arch/arm/boot/zImage_dtb $BIN_DIR/uImage
		cp .config $BIN_DIR/kernel.config
		;;
	"modules")
		$MAKE_CMD modules
		$MAKE_CMD INSTALL_MOD_PATH=$BIN_DIR modules_install
		;;
	*)
		$MAKE_CMD "$@"
		;;
esac
