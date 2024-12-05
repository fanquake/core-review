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
    make \
    patch \
    pkg-config \
    python3 \
    qrencode \
    qt5-base \
    qt5-tools \
    which \
    zeromq

RUN git clone https://github.com/bitcoin/bitcoin && mkdir bitcoin/depends/SDKs

RUN make download -C bitcoin/depends

WORKDIR /bitcoin
