#!/bin/sh

provision() {
    pkg install --yes autoconf \
        automake \
        boost-libs \
        git \
        gmake \
        libevent \
        libtool \
        libzmq4 \
        openssl \
        pkgconf \
        python37

    git clone https://github.com/bitcoin/bitcoin
}

compile() {

    cd bitcoin

    git stash && git checkout master && git clean -fxd

    # Install BerkeleyDB
    ./contrib/install_db4.sh `pwd`
    export BDB_PREFIX=/usr/home/vagrant/bitcoin/db4

    ./autogen.sh
    # --disable-dependency-tracking to work around automake issues
    # https://github.com/bitcoin/bitcoin/issues/14404
    ./configure --with-gui=no --disable-dependency-tracking \
        BDB_LIBS="-L${BDB_PREFIX}/lib -ldb_cxx-4.8" \
        BDB_CFLAGS="-I${BDB_PREFIX}/include"
    gmake -j4
}

case $1 in
	provision)
		provision
	;;
	compile)
        compile
	;;
	*)
	    echo "Usage: freebsd.sh provision|compile"
	;;
esac
