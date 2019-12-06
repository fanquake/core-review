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
        python37 # 3.7 for 11 & 12

    git clone https://github.com/bitcoin/bitcoin

    ./bitcoin/contrib/install_db4.sh `pwd`
}

setup() {

    cd bitcoin

    git clean -fxd && git stash && git checkout master

    if [ -z "$2" ]
    then
        git fetch origin pull/$1/head:$1
        git checkout $1
    fi
}

case $1 in
	provision)
		provision
	;;
	setup)
        setup $2
	;;
	*)
	    echo "Usage: freebsd.sh provision|setup PR"
	;;
esac
