## Howto
0. Prepare ubuntu, install buildtools

1. Download free electron toolchain https://toolchains.bootlin.com/downloads/releases/toolchains/armv7-eabihf/tarballs/armv7-eabihf--glibc--stable-2018.11-1.tar.bz2

2. Place all the things in such structure
    - armv7-eabihf--glibc--stable-2018.11-1
      - source.sh
      - bin
        - arm-buildroot-linux-gnueabihf-gcc
        - arm-buildroot-linux-gnueabihf-ld
        - ...
      - src
        - armada-375-wdmc-gen2.dts
        - kernel-my.config
        - xbuild.sh
        - patch/
          - linux-4.14.150.patch

3. run `xbuild.sh` to build

> Don't modify anything in `armada-375-wdmc-gen2.dts` The file is from fox
