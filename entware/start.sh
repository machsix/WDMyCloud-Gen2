#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

INSTALL_DIR=$1

echo 'export PATH=$PATH:/opt/bin:/opt/sbin:/opt/usr/bin' >> /home/root/.profile
/opt/etc/init.d/rc.unslung start

if [ -d ${INSTALL_DIR}/init.d ]; then
    for i in ${INSTALL_DIR}/init.d/*.sh; do
        $i start
    done
fi

