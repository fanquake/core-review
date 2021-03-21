FROM archlinux:latest

RUN pacman --noconfirm -Syu \
    autoconf \
    automake \
    awk \
    bison \
    boost \
    cmake \
    curl \
    git \
    gcc \
    libevent \
    libnatpmp \
    libtool \
    make \
    miniupnpc \
    patch \
    pkg-config \
    python3 \
    qrencode \
    qt5-base \
    qt5-tools \
    ripgrep \
    valgrind \
    vim \
    which \
    zeromq

RUN git clone https://github.com/bitcoin/bitcoin && mkdir bitcoin/depends/SDKs

RUN make download -C bitcoin/depends

RUN git clone https://github.com/bitcoin-core/bitcoin-maintainer-tools

WORKDIR /bitcoin
