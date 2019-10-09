## Howto
1. Download free electron toolchain https://toolchains.bootlin.com/downloads/releases/toolchains/armv7-eabihf/tarballs/armv7-eabihf--glibc--stable-2018.11-1.tar.bz2

2. Extract all the files

3. Put `source.sh` into the folder and source it before compiling

4. (Optional) Extract `sysroot.tar.xz` to `arm-buildroot-linux-gnueabihf/` to obtain prebuilt `python2`, which is located at `$SYS_ROOT/usr/bin/python`

5. Extract source code to `arm-buildroot-linux-gnueabihf/src` and use `xbuild.sh` to build

## Status

1. Python-2.7: works

2. samba-4.3.11: doesn't work