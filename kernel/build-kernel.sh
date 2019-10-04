#!/bin/bash
set +e
SOURCE_DIR=${1:-"/home/Downloads"}
firmware="WD_MyCloud_GPL_v2.31.195_20190829"
OLD_CWD=`pwd`

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

# download my configuration of Kernel
cd ${SOURCE_DIR}/${firmware}/kernel/${kernel_ver}
curl -L https://github.com/machsix/WDMyCloud-Gen2/raw/master/kernel/kernel.config --output .config
curl -L https://github.com/machsix/WDMyCloud-Gen2/raw/master/kernel/xbuild.sh --output xbuild.sh

# configure Kernel
cd ${SOURCE_DIR}/${firmware}/kernel/${kernel_ver}
# make menuconfig

# build kernel
cd ${SOURCE_DIR}/${firmware}/kernel/${kernel_ver}
./xbuild.sh clean
./xbuild.sh build
#cp ./arch/arm/boot/uImage ${ROOTDIR}/merge/${PROJECT_NAME}/
cp ./arch/arm/boot/uImage ${OUTPUT_DIR}/uImage

# install modules, one of the following
# make -j`nproc` INSTALL_MOD_PATH=${ROOTDIR}/merge/${PROJECT_NAME} modules_install
# ./xbuild.sh install
make -j`nproc` INSTALL_MOD_PATH=${OUTPUT_DIR} modules_install

echo "kernel is at `realpath ${OUTPUT_DIR}/uImage`"
echo "modules are at `realpath ${OUTPUT_DIR}/lib/modules`"
echo -e "\e[1m\e[41m\e[97mKenel built\e[0m"
cd $OLD_CWD