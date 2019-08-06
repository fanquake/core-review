FROM fedora:30

RUN dnf update -y && dnf install --setopt=install_weak_deps=False -y \
    autoconf \
    automake \
    bzip2 \
    cmake \
    gcc-c++ \
    git \
    libtool \
    make \
    patch \
    python3 \
    which \
    xz

RUN git clone https://github.com/bitcoin/bitcoin && mkdir bitcoin/depends/SDKs

RUN make download -C bitcoin/depends

RUN git clone https://github.com/bitcoin-core/bitcoin-maintainer-tools
