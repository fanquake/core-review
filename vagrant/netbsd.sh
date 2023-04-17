#!/bin/sh

# https://cdn.netbsd.org/pub/pkgsrc/packages/NetBSD/amd64/9.3/All/
provision() {
    pkgin -y update && \
    pkgin -y upgrade && \
    pkgin -y install autoconf \
        automake \
        boost \
        clang \
        git \
        gmake \
        libevent \
        libtool \
        mozilla-rootcerts \
        pkg-config \
        python311 \
        sqlite3 \
        zeromq

    touch /etc/openssl/openssl.cnf
    /usr/pkg/sbin/mozilla-rootcerts install

    git clone https://github.com/bitcoin/bitcoin

    echo "export LC_CTYPE=en_US.UTF-8" >> .bash_profile
    echo "echo --with-boost-libdir=/usr/pkg/lib --with-gui=no CPPFLAGS=\"-I/usr/pkg/include\" LDFLAGS=\"-L/usr/pkg/lib\"" >> .bash_profile
}

case $1 in
	provision)
        provision
	;;
	*)
        echo "Usage: netbsd.sh provision"
	;;
esac
