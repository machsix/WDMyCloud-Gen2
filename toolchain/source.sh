
# vim: set filetype=sh:

unset WORKDIR
unset ARCH
unset TARGET_HOST
unset ROOTDIR

if [ "${ORIG_PATH}" == "" ]; then
	export ORIG_PATH="${PATH}"
else
	export PATH="${ORIG_PATH}"
	unset ORIG_PATH
	export ORIG_PATH="${PATH}"
fi

unset CROSS_COMPILE
unset CC
unset CXX
unset AS
unset AR
unset LD
unset NM
unset RANLIB
unset STRIP
unset MY_PREFIX
unset ROOT_FS
unset XLIB_DIR
unset PROJECT_NAME
unset CODE_NAME
unset HOME_DIR

export ARCH=armv7-a
export TUNE=cortex-a9
export TARGET_HOST=arm-Mach6-linux-uclibcgnueabihf

PATH=$(pwd)/arm-Mach6-linux-uclibcgnueabihf/bin/:$PATH
export PATH

export TARGETMACH=${TARGET_HOST}
export CROSS_COMPILE=${TARGET_HOST}-
export CROSS=${TARGET_HOST}
export CC=${CROSS_COMPILE}gcc
export CXX=${CROSS_COMPILE}g++
export AS=${CROSS_COMPILE}as
export AR=${CROSS_COMPILE}ar
export LD=${CROSS_COMPILE}ld
export NM=${CROSS_COMPILE}nm
export RANLIB=${CROSS_COMPILE}ranlib
export STRIP=${CROSS_COMPILE}strip
export BASECFLAGS="-march="$ARCH" -mtune="$TUNE
