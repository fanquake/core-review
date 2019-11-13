#!/bin/sh

provision() {

    # Using automake 1.15 due to
    # https://github.com/bitcoin/bitcoin/issues/14404
    pkg_add automake-1.15.1 \
    autoconf-2.69p2 \
    boost \
    git \
    gmake \
    libevent \
    libtool \
    python-3.7.4 \
    zeromq

    git clone https://github.com/bitcoin/bitcoin
}

setup() {

    if ! grep -q "export AUTOMAKE_VERSION=1.15" .bash_profile ; then
    echo "cd bitcoin/" >> .bash_profile 
    echo "export AUTOMAKE_VERSION=1.15" >> .bash_profile
    echo "export AUTOCONF_VERSION=2.69" >> .bash_profile
    echo "export BDB_PREFIX=/home/vagrant/bitcoin/db4" >> .bash_profile
    echo "export LC_CTYPE=en_US.UTF-8" >> .bash_profile
    echo "echo --with-gui=no CC=cc CXX=c++" >> .bash_profile
    echo "echo 'BDB_LIBS=\"-L/home/vagrant/bitcoin/db4/lib -ldb_cxx-4.8\" BDB_CFLAGS=\"-I/home/vagrant/bitcoin/db4/include\"' " >> .bash_profile
    fi

    cd bitcoin

    git clean -fxd

    git stash && git checkout master

    if [ -z "$2" ]
    then
        git fetch origin pull/$1/head:$1
        git checkout $1
    fi

    # Install BerkeleyDB
    ./contrib/install_db4.sh `pwd` CC=cc CXX=c++

    git log --name-status HEAD^..HEAD
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
