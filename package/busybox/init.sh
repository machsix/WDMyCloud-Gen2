#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

INSTALL_DIR=$1

PREFIX=/usr/local
BIN_DIR=${PREFIX}/bin

chmod +x ${INSTALL_DIR}/files/*

# busybox itself
ln -sf ${INSTALL_DIR}/files/busybox /bin/busybox-1.20.2

# busybox provided programs
ln -sf ${INSTALL_DIR}/files/busybox ${BIN_DIR}/which
busybox_lst=`cat ${INSTALL_DIR}/files/busybox.lst`
for exe in ${busybox_lst}; do
    if [ -z `which $exe` ]; then
        ln -sf ${INSTALL_DIR}/files/busybox  ${BIN_DIR}/${exe}
        echo "Install: ${INSTALL_DIR}/files/busybox => ${BIN_DIR}/${exe}"
    fi
done

# rsync
ln -sf ${INSTALL_DIR}/files/rsync ${BIN_DIR}/rsync

# tmux
ln -sf ${INSTALL_DIR}/files/tmux ${BIN_DIR}/tmux
chmod -x ${INSTALL_DIR}/files/tmux.conf
ln -sf ${INSTALL_DIR}/files/tmux.conf /etc/tmux.conf

# wget
ln -sf ${INSTALL_DIR}/files/wget    ${BIN_DIR}/wget

# nano
ln -sf ${INSTALL_DIR}/files/nano    ${BIN_DIR}/nano
ln -sf ${INSTALL_DIR}/files/nanorc  /etc/nanorc

# tcpdump
ln -sf ${INSTALL_DIR}/files/tcpdump ${BIN_DIR}/tcpdump

# vmstat,w,tload,slabtop
ln -sf ${INSTALL_DIR}/files/lib/libprocps.so.6.0.0 /lib/libprocps.so.6
ln -sf ${INSTALL_DIR}/files/vmstat   ${BIN_DIR}/vmstat
ln -sf ${INSTALL_DIR}/files/w        ${BIN_DIR}/w
ln -sf ${INSTALL_DIR}/files/tload    ${BIN_DIR}/tload
ln -sf ${INSTALL_DIR}/files/slabtop  ${BIN_DIR}/slabtop

# nmap, libncursesw.so.5.7, ncdu, htop, libpcap.so.1.6.2, nping, ncat, ndiff
ln -sf ${INSTALL_DIR}/files/lib/libpcap.so.1.6.2 /lib/libpcap.so.1
ln -sf ${INSTALL_DIR}/files/nmap      ${BIN_DIR}/nmap
ln -sf ${INSTALL_DIR}/files/nping     ${BIN_DIR}/nping
ln -sf ${INSTALL_DIR}/files/ncat      ${BIN_DIR}/ncat
ln -sf ${INSTALL_DIR}/files/ndiff     ${BIN_DIR}/ndiff
ln -sf ${INSTALL_DIR}/files/share/nmap /usr/local/share/nmap
ln -sf ${INSTALL_DIR}/files/lib/libncursesw.so.5.7 /lib/libncursesw.so.5
ln -sf ${INSTALL_DIR}/files/ncdu ${BIN_DIR}/ncdu
ln -sf ${INSTALL_DIR}/files/htop ${BIN_DIR}/htop

# web info
ln -sf ${INSTALL_DIR}/web             /var/www/busybox
