#!/bin/sh

setup() {
    pkg_add autoconf \
        automake \
        boost \
        gdb \
        git \
        gmake \
        libevent \
        libtool \
        pkg-config \
        python37 \
        zeromq

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
    ./configure --with-gui=no CC=cc CXX=c++ \
        BDB_LIBS="-L${BDB_PREFIX}/lib -ldb_cxx-4.8" \
        BDB_CFLAGS="-I${BDB_PREFIX}/include" \
        BOOST_CPPFLAGS="-I/usr/pkg/include" \
        BOOST_LDFLAGS="-L/usr/pkg/lib" \
        CPPFLAGS="-I/usr/pkg/include" \
        LDFLAGS="-L/usr/pkg/lib"
    # TODO: Fix fs issues for gmake check
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
        echo "Usage: netbsd.sh setup|compile"
	;;
esac
