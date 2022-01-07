#!/bin/sh

provision() {

    pkg_add automake-1.16.3 \
    autoconf-2.69p3 \
    boost \
    git \
    gmake \
    libevent \
    libtool \
    python%3.9 \
    sqlite3 \
    zeromq

    git clone https://github.com/bitcoin/bitcoin
}

setup() {

    if ! grep -q "export AUTOMAKE_VERSION=1.16" .bash_profile ; then
    echo "cd bitcoin/" >> .bash_profile 
    echo "export AUTOMAKE_VERSION=1.16" >> .bash_profile
    echo "export AUTOCONF_VERSION=2.69" >> .bash_profile
    echo "export LC_CTYPE=en_US.UTF-8" >> .bash_profile
    echo "echo --with-gui=no CC=cc CXX=c++" >> .bash_profile
    fi

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
        echo "Usage: openbsd.sh provision|setup PR"
	;;
esac
