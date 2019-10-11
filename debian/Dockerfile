FROM ubuntu:16.04
LABEL maintainer="machsix"

RUN  apt-get update -y
RUN  apt-get install -y python vim curl wget git \
                        build-essential \
                        ncurses-dev bc \
                        chrpath gawk texinfo \
                        libsdl1.2-dev whiptail \
                        diffstat cpio libssl-dev
RUN  rm -rf /var/lib/apt/lists/* 
WORKDIR /home
