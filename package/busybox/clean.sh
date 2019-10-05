#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

PREFIX=/usr/local
BIN_DIR=${PREFIX}/bin

# busybox itself
rm -f /bin/busybox-1.20.2

# busybox
for exe in ${BIN_DIR}/*; do
    if [ -L $exe ]; then
        if [ `readlink $exe` == "$INSTALL_DIR/files/busybox" ]; then
            rm -f $exe
            echo "Remove $exe"
        fi
    fi
done

# rsync
rm -f ${BIN_DIR}/rsync

# tmux
rm -f ${BIN_DIR}/tmux
rm -f /etc/tmux.conf

# wget
rm -f ${BIN_DIR}/wget

# nano
rm -f ${BIN_DIR}/nano
rm -f /etc/nanorc

# tcpdump
rm -f ${BIN_DIR}/tcpdump

# vmstat,w,tload,slabtop
rm -f /lib/libprocps.so.6
rm -f ${BIN_DIR}/vmstat
rm -f ${BIN_DIR}/w
rm -f ${BIN_DIR}/tload
rm -f ${BIN_DIR}/slabtop

# nmap, libncursesw.so.5.7, ncdu, htop, libpcap.so.1.6.2, nping, ncat, ndiff
rm -f /lib/libpcap.so.1
rm -f ${BIN_DIR}/nmap
rm -f ${BIN_DIR}/nping
rm -f ${BIN_DIR}/ncat
rm -f ${BIN_DIR}/ndiff
rm -f /usr/local/share/nmap
rm -f /lib/libncursesw.so.5
rm -f ${BIN_DIR}/ncdu
rm -f ${BIN_DIR}/htop

# web info
rm -f /var/www/busybox
