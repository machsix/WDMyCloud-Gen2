#!/bin/bash
# Date: Fri Oct 11 20:31:36 UTC 2019
apt install ncurses-dev bc wget -y
apt-get install -y chrpath gawk texinfo libsdl1.2-dev whiptail diffstat cpio libssl-dev

# Set these two
KVER="4.14.148"
DEVICE="armada-375-wdmc-gen2"

# Download files
wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${KVER}.tar.xz
tar xf linux-${KVER}.tar.xz
(cd ../../../ && source source.sh)
export ARCH="arm"
cp ${DEVICE}.dts linux-${KVER}/arch/arm/boot/dts/
cp kernel-4.15.0-rc6.config linux-${KVER}/.config
cd linux-${KVER}
cp ../patch/linux-${KVER}.patch ./
patch -p1 < linux-${KVER}.patch

# configure
make menuconfig

# Compile
make -j`nproc` zImage
make -j`nproc` $DEVICE.dtb

# Compile modules
make -j`nproc` modules

# Merge image
rm -rf ${DEVICE}
mkdir -p ${DEVICE}/boot
cat arch/arm/boot/zImage arch/arm/boot/dts/$DEVICE.dtb > ${DEVICE}/zImage_dtb
mkimage -A arm -O linux -T kernel -C none -a 0x00008000 -e 0x00008000 -n $DEVICE -d $DEVICE/zImage_dtb ${DEVICE}/boot/uImage

# Install module
make INSTALL_MOD_PATH=${DEVICE} modules_install


# Backup
cp -f .config ${DEVICE}/boot/kernel.config
cp -f arch/arm/boot/dts/${DEVICE}.dts ${DEVICE}/boot/
cp -f linux-${KVER}.patch ${DEVICE}/boot

# Tar files
cd ${DEVICE}
tar -cJvf ../${DEVICE}-linux-${KVER}-modules.tar.xz ./lib
tar -cJvf ../${DEVICE}-linux-${KVER}-boot.tar.xz ./boot

cd ..