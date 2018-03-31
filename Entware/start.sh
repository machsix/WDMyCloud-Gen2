#!/bin/sh
INSTALL_DIR=$1

echo 'export PATH=$PATH:/opt/bin:/opt/sbin:/opt/usr/bin' >> /home/root/.profile
/opt/etc/init.d/rc.unslung start
