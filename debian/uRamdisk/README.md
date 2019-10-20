# Ramdisk for booting system

The ramdisk is modified from [Johns-Q's](https://github.com/Johns-Q/wdmc-gen2). The original work attributes to [Fox](http://anionix.ddns.net/WDMyCloud/usbrecovery.tar.gz).

It will boot the following thing in order:

1. Telnet: if a usb drive with only **a single partition** and **a folder named @rescue in its root** is plugged in.
2. System in USB drive: if a usb drive with **two partitions**, **system installed in the second partition /dev/sdb2**, and **file /sbin/init in the second partition** is plugged.
3. System installed in **/dev/sda3**

To pack ramdisk, check fox's guide http://anionix.ddns.net/WDMyCloud/Other/Repack_uRamdisk.txt