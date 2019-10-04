#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path=$1

#rm -rf $path

# restore orig docker
if [ -f /usr/sbin/docker.bak ]; then
  mv -f /usr/sbin/docker.bak /usr/sbin/docker
fi

# remove bins
rm -rf /sbin/docker*

# remove mountpoint
rm -rf /var/lib/docker

# remove web
rm -rf /var/www/docker
