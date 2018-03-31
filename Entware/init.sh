#!/bin/sh

INSTALL_DIR=$1

# crate web surface
ln -sf $INSTALL_DIR/web /var/www/Entware

# following lines copied from entware manual

unset LD_LIBRARY_PATH
unset LD_PRELOAD

echo "Info: Checking for prerequisites and creating folders..."
echo "Backup opt"

mkdir -p $INSTALL_DIR/opt
# backup opt
cp -av /opt $INSTALL_DIR/opt_bak

# create stock links
if [ -d /opt/firefly ]; then
   ln -sf $(readlink -f /opt/firefly)  $INSTALL_DIR/opt/firefly
fi
if [ -d /opt/perl5.10 ]; then
   ln -sf $(readlink -f /opt/perl5.10)  $INSTALL_DIR/opt/perl5.10
fi

# remove opt folder
rm -rf /opt

# create link
ln -sf $INSTALL_DIR/opt /opt


# no need to create many folders. entware-opt package creates most
for folder in bin etc lib/opkg tmp var/lock
do
  if [ -d "/opt/$folder" ]
  then
    echo "Warning: Folder /opt/$folder exists!"
    echo "Warning: If something goes wrong please clean /opt folder and try again."
  else
    mkdir -p /opt/$folder
  fi
done

echo "Info: Opkg package manager deployment..."
DLOADER="ld-linux.so.3"
URL=http://bin.entware.net/armv7sf-k3.2/installer
curl -o /opt/bin/opkg  $URL/opkg
chmod 755 /opt/bin/opkg
curl -o /opt/etc/opkg.conf $URL/opkg.conf
curl -o /opt/lib/ld-2.27.so $URL/ld-2.27.so
curl -o /opt/lib/libc-2.27.so $URL/libc-2.27.so
curl -o /opt/lib/libgcc_s.so.1 $URL/libgcc_s.so.1
curl -o /opt/lib/libpthread-2.27.so $URL/libpthread-2.27.so
cd /opt/lib
chmod 755 ld-2.27.so
ln -s ld-2.27.so $DLOADER
ln -s libc-2.27.so libc.so.6
ln -s libpthread-2.27.so libpthread.so.0

echo "Info: Basic packages installation..."
/opt/bin/opkg update
/opt/bin/opkg install entware-opt

# Fix for multiuser environment
chmod 777 /opt/tmp

# now try create symlinks - it is a std installation
if [ -f /etc/passwd ]
then
    ln -sf /etc/passwd /opt/etc/passwd
else
    cp /opt/etc/passwd.1 /opt/etc/passwd
fi

if [ -f /etc/group ]
then
    ln -sf /etc/group /opt/etc/group
else
    cp /opt/etc/group.1 /opt/etc/group
fi

if [ -f /etc/shells ]
then
    ln -sf /etc/shells /opt/etc/shells
else
    cp /opt/etc/shells.1 /opt/etc/shells
fi

if [ -f /etc/shadow ]
then
    ln -sf /etc/shadow /opt/etc/shadow
fi

if [ -f /etc/gshadow ]
then
    ln -sf /etc/gshadow /opt/etc/gshadow
fi

if [ -f /etc/localtime ]
then
    ln -sf /etc/localtime /opt/etc/localtime
fi

echo "Info: Congratulations!"
echo "Info: If there are no errors above then Entware was successfully initialized."
echo "Info: Add /opt/bin & /opt/sbin to your PATH variable"
echo "Info: Add '/opt/etc/init.d/rc.unslung start' to startup script for Entware services to start"
echo "Info: Found a Bug? Please report at https://github.com/Entware/Entware/issues"

