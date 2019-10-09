#!/bin/bash -e
# set enviromental variables for toolchain
# syntax: source source.sh TARGET_HOST TOOL_CHAIN_DIR
unset ARCH
unset TARGET_HOST

unset CROSS_COMPILE
unset CC
unset CXX
unset AS
unset AR
unset LD
unset NM
unset RANLIB
unset STRIP
unset BASECFLAGS

export MYARCH=`arch`
export MYBUILD="x86_64"

export ARCH=armv7-a
export TUNE=cortex-a9
export TARGET_HOST=arm-buildroot-linux-gnueabihf
export DEB_HOST_MULTIARCH=arm-linux-gnueabihf
export ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export ROOT_FS=$ROOT_DIR/build
export PATH=$ROOT_DIR/bin:$PATH 
export SYS_ROOT=$ROOT_DIR/arm-buildroot-linux-gnueabihf/sysroot

export CROSS_COMPILE=${TARGET_HOST}-
export CROSS=${TARGET_HOST}
export CC=${CROSS_COMPILE}gcc
export CXX=${CROSS_COMPILE}g++
export AS=${CROSS_COMPILE}as
export AR=${CROSS_COMPILE}ar
export LD=${CROSS_COMPILE}ld
export NM=${CROSS_COMPILE}nm
export GDB=${CROSS_COMPILE}gdb
export RANLIB=${CROSS_COMPILE}ranlib
export STRIP=${CROSS_COMPILE}strip
export BASECFLAGS="-march="$ARCH" -mtune="$TUNE
export PKG_CONFIG=$ROOT_DIR/bin/pkg-config
