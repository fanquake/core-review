#!/bin/sh

provision() {
    pkgin -y update && \
    pkgin -y upgrade && \
    pkgin -y install autoconf \
        automake \
        boost \
        gdb \
        git \
        gmake \
        libevent \
        libtool \
        mozilla-rootcerts \
        pkg-config \
        python37 \
        zeromq

    touch /etc/openssl/openssl.cnf
    /usr/pkg/sbin/mozilla-rootcerts install

    git clone https://github.com/bitcoin/bitcoin

    ./bitcoin/contrib/install_db4.sh `pwd` CC=cc CXX=c++
}

setup() {

    if ! grep -q "cd bitcoin/" .bash_profile ; then
    echo "cd bitcoin/" >> .bash_profile
    echo "export LC_CTYPE=en_US.UTF-8" >> .bash_profile
    echo "echo --with-boost-libdir=/usr/pkg/lib --with-gui=no CPPFLAGS=\"-I/usr/pkg/include\" LDFLAGS=\"-L/usr/pkg/lib\"" >> .bash_profile
    echo "echo 'BDB_LIBS=\"-L/home/vagrant/bitcoin/db4/lib -ldb_cxx-4.8\" BDB_CFLAGS=\"-I/home/vagrant/bitcoin/db4/include\"' " >> .bash_profile
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
        echo "Usage: netbsd.sh provision|setup PR"
	;;
esac
