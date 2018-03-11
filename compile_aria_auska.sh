#!/bin/sh
## ============= Reference ======================
# http://www.cnblogs.com/johnsonshu/p/5003278.html
# https://community.wd.com/t/guide-building-packages-for-the-new-firmware-someone-tried-it/93382/7
# https://community.wd.com/t/guide-cross-compiling-transmission-2-82/91077
# https://github.com/lancethepants/aria2-arm-musl-static/blob/master/aria2.sh

CWD=$(pwd)
HOST_MACH=arm-Auska-linux-gnueabi
WORK_DIR=~/Downloads/Auska
# ======== extract tool chain and set tool chain =============
cd $WORK_DIR
tar xf arm-Auska-linux-gnueabihf.tar.xz
source source.me

LOCAL_DIR=$WORK_DIR/local
SRC_DIR=$WORK_DIR/src
mkdir -p ${LOCAL_DIR}
mkdir -p ${SRC_DIR}

# ======== compile library ===================== 
# zlib
cd $SRC_DIR
wget -N https://zlib.net/zlib-1.2.11.tar.gz 
tar xzf zlib*.tar.gz
cd zlib*/
./configure --static --prefix=${LOCAL_DIR} 
make
make install

# expat
cd $SRC_DIR
wget -N https://github.com/libexpat/libexpat/releases/download/R_2_2_5/expat-2.2.5.tar.bz2
tar xf expat*.tar.bz2
cd expat*/
./configure \
    --host=${HOST_MACH}\
    --enable-shared=no \
    --enable-static=yes \
    --prefix=${LOCAL_DIR}
make
make install

# c-ares
cd $SRC_DIR
wget -N https://c-ares.haxx.se/download/c-ares-1.14.0.tar.gz
tar xzf c-ares*.tar.gz
cd c-ares*/
./configure \
    --host=${HOST_MACH} \
    --enable-shared=no \
    --enable-static=yes \
    --prefix=${LOCAL_DIR}
make
make install

# ssl
cd $SRC_DIR
wget -N https://www.openssl.org/source/openssl-1.0.2n.tar.gz
tar xf openssl*.tar.gz
cd openssl*
./Configure linux-generic32  \
--prefix=${LOCAL_DIR} shared zlib zlib-dynamic \
-D_GNU_SOURCE -D_BSD_SOURCE \
--with-zlib-lib=${LOCAL_DIR}/lib \
--with-zlib-include=${LOCAL_DIR}/include
make CC=$CC
make install CC=$CC

# sqlite
cd $SRC_DIR
wget -N https://www.sqlite.org/2018/sqlite-autoconf-3220000.tar.gz
tar xf sqlite*.tar.gz
cd sqlite*
./configure \
    --host=${HOST_MACH} \
    --prefix=${LOCAL_DIR}\
    --enable-shared=no \
    --enable-static=yes 
    
make
make install

# libssh2
cd $SRC_DIR
wget -N https://www.libssh2.org/download/libssh2-1.8.0.tar.gz
tar xf libssh2*.tar.gz
cd libssh2*
./configure \
    --host=${HOST_MACH} \
    --enable-shared=no \
    --enable-static=yes \
    --prefix=${LOCAL_DIR}
make
make install


# ===================== Compile Aria2 ================
cd $SRC_DIR
wget -N https://github.com/aria2/aria2/releases/download/release-1.33.1/aria2-1.33.1.tar.xz
tar xf aria2*.tar.xz
cd aria2*
cd src
# patch
sed -i 's|"1",\s*1,\s*16|"128", 1, -1|' OptionHandlerFactory.cc
sed -i 's|TEXT_MIN_SPLIT_SIZE,\s*"20M",\s*1_m|TEXT_MIN_SPLIT_SIZE, "4K", 1_k|' OptionHandlerFactory.cc
sed -i 's|TEXT_CONNECT_TIMEOUT,\s*"60"|TEXT_CONNECT_TIMEOUT, "30"|' OptionHandlerFactory.cc
sed -i 's|TEXT_PIECE_LENGTH, "1M", 1_m|TEXT_PIECE_LENGTH, "4k", 1_k|' OptionHandlerFactory.cc
sed -i 's|TEXT_RETRY_WAIT,\s*"0"|TEXT_RETRY_WAIT, "2"|' OptionHandlerFactory.cc
sed -i 's|TEXT_SPLIT,\s*"5"|TEXT_SPLIT, "8"|' OptionHandlerFactory.cc
cd ..
./configure \
   --host=${HOST_MACH} \
   --enable-libaria2 \
   --enable-static \
   --disable-shared \
   --without-libuv \
   --without-appletls \
   --without-gnutls \
   --without-libnettle \
   --without-libgmp \
   --without-libgcrypt \
   --without-libxml2 \
   ZLIB_CFLAGS="-I${LOCAL_DIR}/include" \
   ZLIB_LIBS="-L${LOCAL_DIR}/lib" \
   OPENSSL_CFLAGS="-I${LOCAL_DIR}/include" \
   OPENSSL_LIBS="-L${LOCAL_DIR}/lib" \
   SQLITE3_CFLAGS="-I${LOCAL_DIR}/include" \
   SQLITE3_LIBS="-L${LOCAL_DIR}/lib" \
   LIBCARES_CFLAGS="-I${LOCAL_DIR}/include" \
   LIBCARES_LIBS="-L${LOCAL_DIR}/lib" \
   LIBSSH2_CFLAGS="-I${LOCAL_DIR}/include" \
   LIBSSH2_LIBS="-L${LOCAL_DIR}/lib" \
   EXPAT_CFLAGS="-I${LOCAL_DIR}/include" \
   EXPAT_LIBS="-L${LOCAL_DIR}/lib" \
   ARIA2_STATIC=yes
make LIBS="-lz -lssl -lcrypto -lsqlite3 -lcares -lexpat -lssh2 -ldl"
cd src
$STRIP -s aria2c

