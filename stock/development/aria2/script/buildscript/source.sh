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

export ARCH=armv7-a
export TUNE=cortex-a9
export TARGET_HOST=$1
export PATH=$2/bin:$PATH 

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
#export PKG_CONFIG=$2/bin/pkg-config
