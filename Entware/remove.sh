#!/bin/sh

INSTALL_DIR=$1

sed -i '/export PATH=$PATH:\/opt\/bin:\/opt\/sbin:\/opt\/usr\/bin/d' /home/root/.profile
/opt/etc/init.d/rc.unslung stop

# delete link
rm -f /opt

# copy file back
cp -av $INSTALL_DIR/opt_bak /opt
rm -rf /var/www/Entware
rm -rf $INSTALL_DIR
