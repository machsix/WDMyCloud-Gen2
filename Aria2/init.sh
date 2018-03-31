#!/bin/sh

INSTALL_DIR=$1

ARIA2_DIR=/mnt/HD/HD_a2/Aria2
SHARE_LINK=/shares/Aria2

mkdir -p $ARIA2_DIR
chmod a+rw -R $ARIA2_DIR

if [ -d $SHARE_LINK ]; then
  TARGET_DIR=$(readlink -f $SHARE_LINK)
  if [ "$TARGET_DIR" != "$ARIA2_DIR" ]; then
    cp -a $TARGET_DIR/. $ARIA2_DIR/
    smbif -b Aria2
    rm -rf $TARGET_DIR  #not really necessary
    smbif -a $ARIA2_DIR
  else
    smbif -p Aria2 #make sure it's shared
  fi
else
  smbif -a $ARIA2_DIR # add to share
fi

cat /dev/null > $ARIA2_DIR/aria2.log
cat /dev/null > $ARIA2_DIR/aria2.session

# Webpage for gui
ln -sf $INSTALL_DIR/web /var/www/Aria2

# create link
ln -sf $INSTALL_DIR/sbin/aria2c /usr/sbin/aria2c
