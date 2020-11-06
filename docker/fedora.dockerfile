FROM fedora:33

RUN dnf update -y && dnf install --setopt=install_weak_deps=False -y \
    autoconf \
    automake \
    bzip2 \
    cmake \
    gcc-c++ \
    git \
    libtool \
    make \
    mingw64-gcc-c++.x86_64 \
    mingw64-winpthreads-static.noarch \
    patch \
    python3 \
    ripgrep \
    which \
    xz

RUN git clone https://github.com/bitcoin/bitcoin && mkdir bitcoin/depends/SDKs

RUN make download -C bitcoin/depends

RUN git clone https://github.com/bitcoin-core/bitcoin-maintainer-tools
