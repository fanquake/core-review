#!/bin/sh

setup() {
    apt-get -y update
    apt-get -y install automake \
    autotools-dev \
    build-essential \
    bsdmainutils \
    gdb \
    git \
    libboost-chrono-dev \
    libboost-filesystem-dev \
    libboost-system-dev \
    libboost-test-dev \
    libboost-thread-dev \
    libevent-dev \
    libminiupnpc-dev \
    libssl-dev \
    libzmq3-dev \
    libtool \
    pkg-config \
    python3-zmq

    # Install BerkeleyDB
    cd /home/bitcoin
    ./contrib/install_db4.sh `pwd`
}

compile() {
    export BDB_PREFIX=/home/bitcoin/db4

    cd /home/bitcoin
    git clean -fx
    git status
    ./autogen.sh
    ./configure --with-gui=no \
        BDB_LIBS="-L${BDB_PREFIX}/lib -ldb_cxx-4.8" \
        BDB_CFLAGS="-I${BDB_PREFIX}/include"
    make check -j4
}

case $1 in
	setup)
        setup
	;;
	compile)
        compile
	;;
	*)
        echo "Usage: debian.sh setup|compile"
	;;
esac
