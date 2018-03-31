#!/bin/bash -e
## ============= Reference ======================
# http://www.cnblogs.com/johnsonshu/p/5003278.html
# https://community.wd.com/t/guide-building-packages-for-the-new-firmware-someone-tried-it/93382/7
# https://community.wd.com/t/guide-cross-compiling-transmission-2-82/91077
# https://github.com/lancethepants/aria2-arm-musl-static/blob/master/aria2.sh
# ======== function to reset flags ==================
reset_flags () {
   export LDFLAGS="-L$LOCAL_DIR/lib -L$TOOL_CHAIN_DIR/$TARGET_HOST/lib"
   export CFLAGS="$BASECFLAGS -I$LOCAL_DIR/include -I$TOOL_CHAIN_DIR/$TARGET_HOST/include"
   export CPPFLAGS=$CFLAGS
   export CXXFLAGS=$CFLAGS
   export CROSS_PREFIX=$CROSS_COMPILE
} 

# ======== function to compile lib===================== 
# zlib
compile_zlib () {
  cd $SRC_DIR
  if [ "$1" == "1" ]; then
    wget -N https://zlib.net/zlib-1.2.11.tar.gz 
    tar xzf zlib*.tar.gz
  fi
  cd zlib*/
  reset_flags
  ./configure --prefix=${LOCAL_DIR} 
  make
  make install
}

# expat
compile_expat () {
  cd $SRC_DIR
  if [ "$1" == "1" ]; then
    wget -N https://github.com/libexpat/libexpat/releases/download/R_2_2_5/expat-2.2.5.tar.bz2
    tar xf expat*.tar.bz2
  fi
  cd expat*/
  reset_flags
  ./configure \
    --host=$TARGET_HOST \
    --prefix=${LOCAL_DIR}
    # --enable-shared=no \
    # --enable-static=yes 
  make
  make install
}

# c-ares
compile_cares () {
  cd $SRC_DIR
  if [ "$1" == "1" ]; then
    wget -N https://c-ares.haxx.se/download/c-ares-1.14.0.tar.gz
    tar xzf c-ares*.tar.gz
  fi
  cd c-ares*/
  reset_flags
  ./configure --host=$TARGET_HOST \
    --prefix=${LOCAL_DIR}
    #--enable-shared=no \
    #--enable-static=yes \
  make
  make install
}

# ssl
compile_ssl (){
  cd $SRC_DIR
  if [ "$1" == "1" ]; then
    wget -N https://www.openssl.org/source/openssl-1.0.2n.tar.gz
    tar xf openssl*.tar.gz
  fi
  cd openssl*
  ./Configure linux-generic32  \
    --prefix=${LOCAL_DIR} shared zlib zlib-dynamic \
    --with-zlib-lib=${LOCAL_DIR}/lib \
    --with-zlib-include=${LOCAL_DIR}/include
  make CC=$CC
  make install CC=$CC
}


# sqlite
compile_sqlite () {
  cd $SRC_DIR
  if [ "$1" == "1" ]; then
    wget -N https://www.sqlite.org/2018/sqlite-autoconf-3220000.tar.gz
    tar xf sqlite*.tar.gz
  fi
  cd sqlite*
  reset_flags
  ./configure --host=$TARGET_HOST \
    --prefix=${LOCAL_DIR}
  #--enable-shared=no \
    #--enable-static=yes 

  make
  make install
}

# libssh2
compile_libssh2 () {
  cd $SRC_DIR
  if [ "$1" == "1" ]; then
    wget -N https://www.libssh2.org/download/libssh2-1.8.0.tar.gz
    tar xf libssh2*.tar.gz
  fi
  cd libssh2*
  reset_flags
  ./configure --host=$TARGET_HOST \
    --prefix=${LOCAL_DIR}
  #--enable-shared=no \
    #--enable-static=yes 

  make LIBS="-lz -lssl -lcrypto"
  make install
}

# aria2c
compile_aria2c () {
  cd $SRC_DIR
  if [ "$1" == "1" ];then
    wget -N https://github.com/aria2/aria2/releases/download/release-1.33.1/aria2-1.33.1.tar.xz
    tar xf aria2*.tar.*
  fi
  cd aria2*
  cd src
  # patch https://yadominjinta.github.io/break-aria2-limit/
  sed -i 's|"1",\s*1,\s*16|"128", 1, -1|' OptionHandlerFactory.cc
  sed -i 's|TEXT_MIN_SPLIT_SIZE,\s*"20M",\s*1_m|TEXT_MIN_SPLIT_SIZE, "4K", 1_k|' OptionHandlerFactory.cc
  sed -i 's|TEXT_CONNECT_TIMEOUT,\s*"60"|TEXT_CONNECT_TIMEOUT, "30"|' OptionHandlerFactory.cc
  sed -i 's|TEXT_PIECE_LENGTH, "1M", 1_m|TEXT_PIECE_LENGTH, "4k", 1_k|' OptionHandlerFactory.cc
  sed -i 's|TEXT_RETRY_WAIT,\s*"0"|TEXT_RETRY_WAIT, "2"|' OptionHandlerFactory.cc
  sed -i 's|TEXT_SPLIT,\s*"5"|TEXT_SPLIT, "8"|' OptionHandlerFactory.cc
  cd ..
  reset_flags
  ARIA2_STATIC=yes  ./configure --host=$TARGET_HOST \
    --enable-static \
    --disable-shared \
    --without-libuv \
    --without-appletls \
    --without-gnutls \
    --without-libnettle \
    --without-libgmp \
    --without-libgcrypt \
    --without-libxml2 \
    --prefix=$LOCAL_DIR \
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
    EXPAT_LIBS="-L${LOCAL_DIR}/lib"  
  # --enable-libaria2 

  read -n1 -r -p "Check configuration for aria2, press space to continue..." key
  if [ "$key" = '' ]; then
    make LIBS="-lz -lssl -lcrypto -lsqlite3 -lcares -lexpat -lssh2 -ldl"
    make install
    cd $LOCAL_DIR/bin
    $STRIP -S aria2c
  else
    exit
  fi
}

BUILD_DIR=$HOME/Downloads/DSM
LOCAL_DIR=$BUILD_DIR/local
SRC_DIR=$BUILD_DIR/src

mkdir -p $BUILD_DIR
mkdir -p $LOCAL_DIR
mkdir -p $SRC_DIR

# ======== set tool chain and enviroment variables  =============
cd $BUILD_DIR
# download toolchain
#wget https://sourceforge.net/projects/dsgpl/files/DSM%206.2%20Tool%20Chains/Marvell%20Armada%20375%20Linux%203.2.40/armada375-gcc493_glibc220_hard-GPL.txz
#tar -xf armada*.txz

TARGET_HOST=$(find . -maxdepth 1 -type d -name 'arm*')
TARGET_HOST=${TARGET_HOST:2}
TOOL_CHAIN_DIR=$BUILD_DIR/$TARGET_HOST

source $HOME/Downloads/buildscript/source.sh $TARGET_HOST $TOOL_CHAIN_DIR


# ======= compile libraries =================
reset_flags
echo " ==============================================="
echo " Toolchain in:         "$TOOL_CHAIN_DIR"/bin"
echo " Code is stored at:    "$SRC_DIR
echo " CC is                 "$CC
echo " Build results are in: "$BUILD_DIR
echo " CFLAGS:               "$CFLAGS
echo " LDFLAGS:              "$LDFLAGS
echo " ==============================================="

#cd ~/Downloads
#$CC --static -o Helloworld helloworld.c
echo "Check if everything is correct"
read -n1 -r -p "Press space to continue..." key
if [ "$key" = '' ]; then
  # compile_xx 1 : download this stuff
  # compile_xx 0 : do not redownload this stuff
  compile_zlib 1
  compile_expat 1
  compile_ssl 1
  compile_cares 1
  compile_sqlite 1
  compile_libssh2 1
  compile_aria2c 1
else
  echo "quit"
  exit
fi


