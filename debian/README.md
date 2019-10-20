# Install Debian on WD MyCloud Gen2

> This guide comes with no warranty. You must use this program at your own risk. I'm NOT responsible for anything.

After wasting a lot of time on :shit: WD system. I finally moved to the Clean Debian provided by [Fox](https://community.wd.com/t/clean-os-debian-openmediavault-and-other-firmwares/93714). The installation and tweaking take a large amount of time. And honestly speaking, I don't know how long I will use this NAS since the official support of the Debian Jessie has ended.

## Installation

Installation is pretty straightforward. If you don't want to save your data, you can follow Fox's guide http://anionix.ddns.net/WDMyCloud/WDMyCloud-Gen2/Debian/_howto_en.txt. Most importantly, you need to have /dev/sda1 as a swap with 1G size. /dev/sda3 as your linux root and it should start at 1G and end at 4G. /dev/sda2 as the data drive.

If you want to save your data, you can take the HDD out of the device. Then connect it to a Linux machine. Next, use Gparted to delete all the partitions except the data drive (it should be /dev/sda7). Next, you can use Gparted GUI to expand the partition to make it left sector start at 4G (This takes a lot of time). Then create the rest partitions. Also, you need to renumber the partitions if they don't have the correct sequence. This can be achieved by deleting the partition in parted first and then using `rescue` command.

The rootfs can be found from any of the following location:

1. https://fox-exe.ru/WDMyCloud/WDMyCloud-Gen2/Debian/jessie-rootfs.tar.gz
2. https://github.com/machsix/WDMyCloud-Gen2/releases/download/v1.1/jessie-rootfs.tar.gz
3. https://drive.google.com/open?id=0B_6OlQ_H0PxVcjdsVVpYVGRVR0k

It was built by Fox for Debian 9 (Jessie). I trust its safety.

## Fix and upgrade

0. Change root password: User / Password for login (WebGui, SSH, etc…) is root/mycloud or admin/mycloud. Do this first!!

1. /etc/fstab
```
<<<
devpts  /dev/pts  devpts  defaults,gid5,mode=620 0 0
>>>
devpts  /dev/pts  devpts  defaults,gid=5,mode=620 0 0
```

2. /etc/apt/sources.list
```
deb  http://deb.debian.org/debian stable main contrib non-free
deb-src  http://deb.debian.org/debian stable main contrib non-free

deb  http://deb.debian.org/debian stable-updates main contrib non-free
deb-src  http://deb.debian.org/debian stable-updates main contrib non-free

deb http://security.debian.org/ stable/updates main contrib non-free
deb-src http://security.debian.org/ stable/updates main contrib non-free
```

3. Delete  all files in `/etc/udev/rules.d/`

4. (Optional) ipv6: If you get your ipv6 address from your router or native ipv6 from ISP, it's very likely your ipv6 is obtained by `ipv6 slaac`. For example, ASUS router uses dnsmasq to handle dhcp and dnsmasq has an option `ra-stateless` to send router advertisements to help you configure ipv6. If this is the case, modify `/etc/newwork/interfaces` to be the following:
```
# interfaces(5) file used by ifup(8) and ifdown(8)
# Include files from /etc/network/interfaces.d:
source-directory /etc/network/interfaces.d

# loopback
auto lo
iface lo inet loopback
iface lo inet6 loopback

# main network interface
auto eth0
allow-hotplug eth0
iface eth0 inet dhcp
iface eth0 inet6 auto
	pre-up echo 1 > /proc/sys/net/ipv6/conf/$IFACE/accept_ra
	pre-up echo 0 > /proc/sys/net/ipv6/conf/$IFACE/disable_ipv6
```
**Never delete /etc/network/if-pre-up.d/eth0-setmac if you set router to assign ip based on mac address**

5. (optional) set hostname
6. update system and dist
```
sudo apt clean
sudo apt update
sudo apt upgrade       # For regular/minor upgrades
sudo apt dist-upgrade  # For major release upgrades only
sudo apt autoremove
/sbin/shutdown -r now  #
```
7. (optional) update kernel. Fox has built some kernel: https://fox-exe.ru/WDMyCloud/WDMyCloud-Gen2/Debian/Dev/. I have only tested `Debian-kernel-bin_4.15.0-rc6.tar.gz`. I built my own kernel with additional IPV6 module. You can check it out in the `kernel` folder. Play carefully with the kernel. You may not boot your device if the kernel is not compatible with your system. If something wrong happens, download https://github.com/machsix/WDMyCloud-Gen2/releases/download/v1.1/usbrecovery.tar.gz and put the boot folder in your usb drive. If you didn't messy up with your configuration files in `/etc` and `/lib`, you may still boot the system up with the kernel in the recovery. Otherwise, you have to take the device apart. **Don't play with the uRamdisk**


## Tweaking

### NGINX+PHP+postgresql

Guide: https://tecadmin.net/install-nextcloud-on-debian/
1. `apt install nginx-full`
2. Install php from https://packages.sury.org/php/README.txt
or
```
wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add -
echo "deb https://packages.sury.org/php/ buster main" > /etc/apt/sources.list.d/php.list
apt-get update
```

3. Install php
```
# all packages needed by tt-rss
apt-get install -y php7.4-fpm php7.4-cli \
                   php7.4-common php7.4-fpm \
                   php7.4-intl php7.4-json php7.4-mbstring \
                   php7.4-opcache php7.4-pgsql php7.4-readline php7.4-xml
```

4. Install postgresql
```
apt install postgresql
```

5. Move postgresql data
```
pg_ctlcluster 11 main stop
mkdir -p /home/postgres
mv /var/lib/postgresql/.psql_history /home/postgres/
mv /var/lib/postgresql/.bash_history /home/postgres/
mv /var/lib/postgresql/11 /home/postgres/
chown -R postgres:postgres /home/postgres
pg_ctlcluster 11 main start
```
6. Set SQL password
```
su -postgres -c psql
\password postgres
\q
```

7. Set Login method, add the line `host    all             all             192.168.1.0/24          md5` to `/etc/postgresql/11/main/pg_hba.conf`. Restart `pg_ctlcluster 11 main restart`

### Install python
```
apt install -y python python3 python-setuptools python3-setuptools \
    python3-requests python3-lxml python3-psycopg python3-sqlalchemy \
    python3-flask

# Install pip, never install pip from apt repository because it will also install gcc and other development tools that you will never use

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
```

### Get SSL certificate
```bash
curl https://get.acme.sh | sh
```
### Rebuild samba

samba-4.3.11, the one shipped with WD firmware has better performance than the latest version.

Check https://github.com/machsix/WDMyCloud-Gen2/tree/master/debian/samba-4.3.11 to learn how to patch upstream code and built it.


### NodeJS
```bash
# nodejs
curl https://nodejs.org/dist/v10.16.3/node-v10.16.3-linux-armv7l.tar.xz | tar xz -C /usr/local
# yarn, don't use npm, which is too huge
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
echo "export NODE_ENV=production" > /etc/profile.d/nodejs.sh
```
### Redis
```
apt install -y redis
# add the following to /etc/redis/redis.conf
# maxmemory 50M
# maxmemory-policy allkeys-lru
```

### RSShub
```bash
apt install redis -y
git clone --depth 1 -b mini --single-branch https://github.com/machsix/RSSHub.git
cd RSSHub
yarn install --production
```

## Reference 1

https://community.wd.com/t/clean-os-debian-openmediavault-and-other-firmwares/93714/1258?u=genius2k

>
    Use this kernel: https://github.com/MarvellEmbeddedProcessors/linux-marvell 31
    Also need some patches for support our device + dts file (All you can find on my google.drive)
    Good news: Marvell Armada 370/375/380/385/+ have official support in mainline linux kernel. But still need dts and some patches.
    For speedup Samba - Need port changes from WD sources. Or use Samba from “WD GPL Source code archive”.
    Green led - Debian boot OK.
    Yellow led - HDD usage.
    For change this - go to /sys/class/leds/[led_name]/
    cat trigger - show list of available triggers
    echo default-on > trigger - Change trigger
    echo 1 > brightness - Turn of/off the led (Also changes trigger to “default-on”)
