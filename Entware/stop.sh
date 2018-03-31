#!/bin/sh
sed -i '/export PATH=$PATH:\/opt\/bin:\/opt\/sbin:\/opt\/usr\/bin/d' /home/root/.profile
/opt/etc/init.d/rc.unslung stop
