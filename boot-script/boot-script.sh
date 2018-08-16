#! /bin/sh -e
CRONTAB=/var/spool/cron/crontabs/root
CONFIG=/usr/local/config
BOOTRUN=/tmp/bootscript-run

# Remove boot-script from crontab and
# recover crontab
sleep 30
cd $CONFIG
crontab -l > crontab.orig
sed -i '/boot-script/d' crontab.orig
cp crontab.orig $CRONTAB

# don't run twice
if [ -f $BOOTRUN ]; then exit 0
fi
touch $BOOTRUN


# boot code comes here
# enable passwordless login 
/usr/bin/cp -r /mnt/HD/HD_a2/Public/.ssh /home/root/
# crack webgui
rm /usr/local/model/web/pages/function/define.js
ln -sf /mnt/HD/HD_a2/Public/define.js /usr/local/model/web/pages/function/define.js
