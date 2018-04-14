Collection of packages for WDMyCloud Gen2
======
### Introduction

> Give a man a fish and you feed him for a day; teach a man to fish and you feed him for a lifetime
> 授人以鱼不如授人以渔

This is a fork of [Auska repository](https://github.com/Auska/mycloud-plugin). You can visit [His blog](https://blog.auska.win) to learn more.

I added **buildscript** folder, which contains:
- compile_aria2.sh: the script I created to build aria2c program with [DSMC toolchain](httpss://sourceforge.net/projects/dsgpl/files/DSM%206.2%20Tool%20Chains/Marvell%20Armada%20375%20Linux%203.2.40/armada375-gcc493_glibc220_hard-GPL.txz), as wll as some necessary libraries.
- source.sh: the script to set enviromental variables for toolchain

I also packed some program and they are placed in **Release** folder:
- WDMyCloud_Aria2_1.33.1.bin: Aria2 with max-conn-per-server=10
- WDMyCloud_Aria2_1.33.1(100threads).bin: Aria2 with max-conn-per-server=100
- WDMyCloud_Entware_1.0.0.bin: Entware software repository, contains more 2000+ package. You need to have internet when installing this program since some files need to be downloaded from Entware official website. Depending on your internet speed, the installation may take a while. Learn more about Entware at [Entware Github](https://github/Entware/Entware/wiki)
- Other packages: packed from Auska's original work. **NOT TESTED, USE AT YOUR OWN RISK**

I hope this repository can help anyone having interest to learn and cross compile program for WDMyCloud Gen2

### Package Build Instructions:
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
mkdir -p Release
mv WDMyCloud* Release/
cd Release
for i in *; do mv $i ${i%\(*\)}; done
```
### "Crack" WdMycloud
Enable app installation
 1. Go to web interface
 2. In “URL” field (In your browser) type: `javascript:APP_INSTALL_FUNCTION=1; APPS_EULA=1; check_app_eula();`
    Alternative way: Press [ctrl] + [shift] + [i], open “Console” tab, put this and hit [enter]:`APP_INSTALL_FUNCTION=1; APPS_EULA=1; check_app_eula();`
 3. Go to Apps tab and install “WD_Crack” app.
 4. Refresh page and install any other apps.

Alternatively:
```
cd /mnt/HD/HD_a2/Public
curl -o define.js https://github.com/machsix/WDMyCloud-Gen2/raw/master/define.js
rm /usr/local/model/web/pages/function/define.js
ln -sf /mnt/HD/HD_a2/Public/define.js /usr/local/model/web/pages/function/define.js
```
run ` APPS_EULA=1; check_app_eula();` in console
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

