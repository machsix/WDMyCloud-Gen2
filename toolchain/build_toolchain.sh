#/bin/bash
sudo apt-get update
sudo apt-get upgrade

sudo apt-get -y install autoconf
sudo apt-get -y install gperf
sudo apt-get -y install bison
sudo apt-get -y install flex
sudo apt-get -y install texinfo
sudo apt-get -y install help2man
sudo apt-get -y install ncurses-dev
cd ~/Downloads
git clone https://github.com/crosstool-ng/crosstool-ng.git
cd crosstool*
./bootstrap

./configure --prefix=$HOME/Downloads/wd_crosstool
make
make install
export PATH=$HOME/Downloads/wd_crosstool/bin:$PATH
mkdir -p $HOME/Downloads/Mach6_toolchain
cd $HOME/Downloads/Mach6_toolchain
ct-ng menuconfig
ct-ng build
ln -s $HOME/Downloads/Mach6_toolchain/x-tool/arm-Mach6-linux-uclibcgnueabihf $HOME/Downloads/Mach6/arm-Mach6-linux-uclibcgnueabihf
