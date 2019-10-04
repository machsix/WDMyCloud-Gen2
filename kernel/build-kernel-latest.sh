#!/bin/bash
set +e
SOURCE_DIR=${1:-"/home/Downloads"}
firmware="WD_MyCloud_GPL_v2.31.195_20190829"
OLD_CWD=`pwd`
apt install -y flex bison

# version info
cd ${SOURCE_DIR}/${firmware}
firmware_ver=${firmware##*_}
toolchain=`find ./toolchain -maxdepth 1 -type d -name "armv7*"`
toolchain=`basename $toolchain`
kernel_ver='4.4.194'
echo -e "\e[1m\e[41m\e[97mFirmware:   ${firmware_ver}\e[0m"
echo -e "\e[1m\e[41m\e[97mKernel:     ${kernel_ver}\e[0m"
echo -e "\e[1m\e[41m\e[97mToolchain:  ${toolchain}\e[0m"

# clean folder
OUTPUT_DIR=${SOURCE_DIR}/build/${firmware_ver}
if [ -d ${OUTPUT_DIR} ]; then
  rm -rf ${OUTPUT_DIR}
fi
mkdir -p ${OUTPUT_DIR}
echo ${firmware_ver} > ${SOURCE_DIR}/build/version

# load TOOLCHAIN
cd ${SOURCE_DIR}/${firmware}/toolchain
source source.me
mkdir -p ${ROOTDIR}/merge/${PROJECT_NAME}/

# download kernel_ver
cd ${SOURCE_DIR}/${firmware}/kernel
curl -L https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${kernel_ver}.tar.xz --output linux-${kernel_ver}.tar.xz
tar xf linux-${kernel_ver}.tar.xz
cd ${SOURCE_DIR}/${firmware}/kernel/linux-${kernel_ver}
curl -L https://github.com/machsix/WDMyCloud-Gen2/raw/master/kernel/kernel.config --output .config
curl -L https://github.com/machsix/WDMyCloud-Gen2/raw/master/kernel/xbuild.sh --output xbuild.sh
curl -L https://github.com/machsix/WDMyCloud-Gen2/raw/master/kernel/tool/mkimage --output mkimage
chmod +x xbuild.sh mkimage
cd ${SOURCE_DIR}/${firmware}/kernel/linux-${kernel_ver}/scripts
curl -L https://github.com/machsix/WDMyCloud-Gen2/raw/master/kernel/tool/mkuboot.sh --output mkuboot.sh
chmod +x mkuboot.sh