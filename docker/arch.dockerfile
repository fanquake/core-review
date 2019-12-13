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
    ripgrep \
    which

RUN git clone https://github.com/bitcoin/bitcoin && mkdir bitcoin/depends/SDKs

RUN make download -C bitcoin/depends

RUN git clone https://github.com/bitcoin-core/bitcoin-maintainer-tools
