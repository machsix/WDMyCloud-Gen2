#!/bin/bash
set +e
SOURCE_DIR=${1:-"/home/Downloads"}
firmware="WD_MyCloud_GPL_v2.31.195_20190829"
OLD_CWD=`pwd`
OVERLAY=1

# version info
cd ${SOURCE_DIR}/${firmware}
firmware_ver=${firmware##*_}
toolchain=`find ./toolchain -maxdepth 1 -type d -name "armv7*"`
toolchain=`basename $toolchain`
kernel_ver=`find ./kernel -maxdepth 1 -type d -name "linux*"`
kernel_ver=`basename $kernel_ver`
echo -e "\e[1m\e[41m\e[97mFirmware:   ${firmware_ver}\e[0m"
echo -e "\e[1m\e[41m\e[97mKernel:     ${kernel_ver}\e[0m"
echo -e "\e[1m\e[41m\e[97mToolchain:  ${toolchain}\e[0m"

# overlay patch
if [ $OVERLAY == "1" ];then
  cd ${SOURCE_DIR}/${firmware}/kernel/${kernel_ver}
  patch -p1 < ${OLD_CWD}/overlayfs-patches/overlayfs.v18-3.10-rc7.patch
  echo -e "\e[1m\e[41m\e[97mOverlay:  PATCHED\e[0m"
fi

cd ${OLD_CWD}
