FROM archlinux/base

RUN pacman --noconfirm -Syu autoconf \
    automake \
    awk \
    cmake \
    curl \
    git \
    gcc \
    libtool \
    make \
    patch \
    pkg-config \
    python3 \
    which

RUN git clone https://github.com/bitcoin/bitcoin && mkdir bitcoin/depends/SDKs
