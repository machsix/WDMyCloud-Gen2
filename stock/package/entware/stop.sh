#!/bin/sh
sed -i '/export PATH=$PATH:\/opt\/bin:\/opt\/sbin:\/opt\/usr\/bin/d' /home/root/.profile
/opt/etc/init.d/rc.unslung stop

INSTALL_DIR=/mnt/HD/HD_a2/Nas_Prog/entware
if [ -d ${INSTALL_DIR}/init.d ]; then
    for i in ${INSTALL_DIR}/init.d/*.sh; do
        $i stop
    done
fi
