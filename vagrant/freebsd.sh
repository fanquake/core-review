#!/bin/sh

provision() {
    pkg install --yes \
        autoconf \
        automake \
        boost-libs \
        git \
        gmake \
        libevent \
        libtool \
        libzmq4 \
        pkgconf \
        python37 \
        sqlite3

    git clone https://github.com/bitcoin/bitcoin
}

case $1 in
	provision)
		provision
	;;
	*)
	    echo "Usage: freebsd.sh provision"
	;;
esac
