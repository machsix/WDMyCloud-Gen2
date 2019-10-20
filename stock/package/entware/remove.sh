#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

INSTALL_DIR=$1
APKG_MODULE="entware"

sed -i '/export PATH=$PATH:\/opt\/bin:\/opt\/sbin:\/opt\/usr\/bin/d' /home/root/.profile
/opt/etc/init.d/rc.unslung stop

# delete link
rm -f  /opt
rm -f  /var/www/${APKG_MODULE}

CWD=`pwd`
cd $INSTALL_DIR
backup_name="enteware-`date +%Y%M%d`.tar.gz"
tar cxvf $backup_name opt
if [ -f /mnt/HD/HD_a2/Public/$backup_name ] && rm -r $backup_name
mv -f $backup_name /mnt/HD/HD_a2/Public/
cd $CWD

# copy file back
cp -av $INSTALL_DIR/opt_bak/* /opt
rm -rf $INSTALL_DIR
