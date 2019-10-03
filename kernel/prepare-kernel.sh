#!/bin/bash
set +e
SOURCE_DIR=${1:-"/home/Downloads"}
firmware="WD_MyCloud_GPL_v2.31.195_20190829"
#firmware="WD_MyCloud_GPL_v2.31.149_20181015"
OLD_CWD=`pwd`

add_32bit (){
  #docker create -it --name ubuntu -v $(pwd)/ubuntu:/home ubuntu:xenial bash
  dpkg --add-architecture i386
  apt -y update
  apt -y install libc6:i386 libncurses5:i386 libstdc++6:i386 || true
  apt -y install multiarch-support
  apt -y install libxml2 libxml2:i386
}
apt -y install curl build-essential ncurses-dev bc

# Download source code
# https://support.wdc.com/downloads.aspx?p=269&lang=en
# http://downloads.wdc.com/gpl/WD_MyCloud_GPL_v2.30.193_20180502.tar.gz
# https://mega.nz/#!oohRjKzZ!IZ6HTUHEiSZHQNOllvnF-U9AW6UQoAsnNy6039bMKMY
# USB Recovery:https://mega.nz/#!R1hFxIDR!CjPQt0dYswlXcCvdIuqUXhusKgc31j9KQc_lZXDs--c
mkdir -p ${SOURCE_DIR}

cd ${SOURCE_DIR}
curl -L http://downloads.wdc.com/gpl/${firmware}.tar.gz --output ${firmware}.tar.gz
tar xf ${firmware}.tar.gz

cd ${SOURCE_DIR}/${firmware}/toolchain
tar xf *.tar.gz

cd ${SOURCE_DIR}/${firmware}/kernel
for i in *.tar.gz; do
  tar xf $i
done

cd $OLD_CWD