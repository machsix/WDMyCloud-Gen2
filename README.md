Collection of packages for WDMyCloud Gen2
======
#### Introduction

> Give a man a fish and you feed him for a day; teach a man to fish and you feed him for a lifetime
> 授人以鱼不如授人以渔

This is a fork of [Auska repository](https://github.com/Auska/mycloud-plugin). You can visit [His blog](https://blog.auska.win) to learn more.

I added **buildscript** folder, which contains:
- compile_aria2.sh: the script I created to build aria2c program with [DSMC toolchain](httpss://sourceforge.net/projects/dsgpl/files/DSM%206.2%20Tool%20Chains/Marvell%20Armada%20375%20Linux%203.2.40/armada375-gcc493_glibc220_hard-GPL.txz), as wll as some necessary libraries.
- source.sh: the script to set enviromental variables for toolchain

I also packed some program and they are placed in **Release** folder:
- WDMyCloud_Aria2_1.33.1.bin: Aria2 with max-conn-per-server=10
- WDMyCloud_Aria2_1.33.1(100threads).bin: Aria2 with max-conn-per-server=100
- Other packages: packed from Auska's original work. **NOT TESTED, USE AT YOUR OWN RISK**

I hope this repository can help anyone having interest to learn and cross compile program for WDMyCloud Gen2

#### Package Build Instructions:
```
for i in */; do 
  if [ "$i" != "Aria2" ]; then  
      if [ -f "$i/install.sh" ]; then   
         cd $i;       
         find . -name '*.sh' -exec chmod +x '{}' \;
         chmod +x sbin/*
         chmod +x bin/*
         ../mksapkg -E -s -m WDMyCloud;   
            cd ..;    
      fi; 
  fi;
done
```

### Devices
	- WDMyCloudEX4: Marvell Kirkwood 88F6282A1 @ 2.0 GHz (single-core)
	- WDMyCloudEX2: Marvell ARMADA 370 (MV6710) (Single Core ARMv7 @ 1.2 GHz)
	- WDMyCloudMirror
	- WDMyCloud
	- WDMyCloudEX4100
	- WDMyCloudDL4100
	- WDMyCloudEX2100
	- WDMyCloudDL2100
	- WDMyCloudMirrorGen2
	- MyCloudEX2Ultra
	- MyCloudPR4100
	- MyCloudPR2100

### License
    [MIT](https://opensource.org/licenses/MIT)

