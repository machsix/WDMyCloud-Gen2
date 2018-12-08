#!/bin/bash -e

# Switch to root user
firmware="WD_MyCloud_GPL_v2.30.193_20180502"
#firmware="WD_MyCloud_GPL_v2.31.149_20181015"
cwd=`pwd`
# Download source code
# https://support.wdc.com/downloads.aspx?p=269&lang=en
# http://downloads.wdc.com/gpl/WD_MyCloud_GPL_v2.30.193_20180502.tar.gz
# https://mega.nz/#!oohRjKzZ!IZ6HTUHEiSZHQNOllvnF-U9AW6UQoAsnNy6039bMKMY
# USB Recovery:https://mega.nz/#!R1hFxIDR!CjPQt0dYswlXcCvdIuqUXhusKgc31j9KQc_lZXDs--c
mkdir -p ~/Downloads
cd ~/Downloads
wget http://downloads.wdc.com/gpl/${firmware}.tar.gz
tar xf ${firmware}.tar.gz

# Load toolchain
cd ~/Downloads/${firmware}/toolchain
tar xf armv7-marvell-linux-gnueabi-softfp_i686_64K_Dev_20131002.tar.gz
source source.me
export ROOT_FS=${WORKDIR}/../firmware/module/crfs
export INSTALL_MOD_PATH=${ROOT_FS}
export NCORE=20   #number of core you have
# Untar code
cd ~/Downloads/${firmware}/kernel
tar xf linux-3.10.39-2014_T2.0p4.tar.gz
tar xf netatop-0.5.tar.gz
# Download my kernel config and xbuild
cd ~/Downloads/${firmware}/kernel/linux-3.10.39-2014_T2.0p4
cat ${cwd}/kernel.config > .config
cat ${cwd}/xbuild.sh > xbuild.sh
./xbuild.sh clean

# Configure Kernel
make menuconfig
read -n1 -r -p "Press space to build ..." key
if [ "$key" = '' ]; then
  ./xbuild.sh build
  ./xbuild.sh install
else
  echo "quit"
  exit
fi

echo "kernel is at ${ROOTDIR}/firmware/merge/uImage"
echo "modules are at ${ROOTDIR}/firmware/module/crfs/lib/modules"
