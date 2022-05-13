#!/bin/sh

provision() {
    # https://ftp.openbsd.org/pub/OpenBSD/7.0/packages/amd64/
    pkg_add automake-1.16.3 \
    autoconf-2.71 \
    bash \
    boost \
    ccache \
    git \
    gmake \
    gtar-1.34 \
    libevent \
    libtool \
    python%3.9 \
    sqlite3 \
    zeromq
}

case $1 in
	provision)
        provision
	;;
	*)
        echo "Usage: openbsd.sh provision"
	;;
esac
