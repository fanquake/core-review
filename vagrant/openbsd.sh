#!/bin/sh

setup() {
    # Using automake 1.15 due 
    # to https://github.com/bitcoin/bitcoin/issues/14404
    pkg_add automake-1.15.1 \
    autoconf-2.69p2 \
    boost \
    git \
    gmake \
    libevent \
    libtool \
    python-3.6.6p1 \
    zeromq

    # Install BerkeleyDB
    cd /home/bitcoin
    ./contrib/install_db4.sh `pwd` CC=cc CXX=c++
}

compile() {
    export AUTOMAKE_VERSION=1.15
    export AUTOCONF_VERSION=2.69
    export BDB_PREFIX=/home/bitcoin/db4
    export LC_CTYPE=en_US.UTF-8

    cd /home/bitcoin
    git clean -fx
    git status
    ./autogen.sh
    ./configure --with-gui=no CC=cc CXX=c++ \
        BDB_LIBS="-L${BDB_PREFIX}/lib -ldb_cxx-4.8" \
        BDB_CFLAGS="-I${BDB_PREFIX}/include"
    gmake -j4
}

case $1 in
	setup)
        setup
	;;
	compile)
        compile
	;;
	*)
        echo "Usage: openbsd.sh setup|compile"
	;;
esac
