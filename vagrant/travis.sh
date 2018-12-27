#!/bin/sh

setup() {
    apt-get -y update
    apt-get -y install automake \
    autotools-dev \
    build-essential \
    bsdmainutils \
    ca-certificates \
    ccache \
    cmake \
    curl \
    gdb \
    git \
    libdbus-1-dev \
    libharfbuzz-dev \
    libprotobuf-dev \
    libtool \
    pkg-config \
    protobuf-compiler \
    python3-zmq \
    qtbase5-dev \
    qttools5-dev-tools
}

compile() {
    cd /home/bitcoin
    git clean -fx
    git status
    cd depends
    make NO_QT=1 NO_UPNP=1 DEBUG=1 ALLOW_HOST_PACKAGES=1 RAPIDCHECK=1 -j6
    cd ..
    ./autogen.sh
    ./configure --prefix=`pwd`/depends/x86_64-pc-linux-gnu \
        --enable-zmq \
        --with-gui=qt5 \
        --enable-glibc-back-compat \
        --enable-reduce-exports \
        --enable-debug CXXFLAGS="-g0 -O2"
    make -j4
}

case $1 in
	setup)
        setup
	;;
	compile)
        compile
	;;
	*)
        echo "Usage: travis.sh setup|compile"
	;;
esac
