FROM fedora:36

RUN dnf update -y && dnf install --setopt=install_weak_deps=False -y \
    autoconf \
    automake \
    bison \
    boost-devel \
    bzip2 \
    cmake \
    gcc-c++ \
    git \
    libevent-devel \
    libnatpmp-devel \
    libtool \
    make \
    mingw64-gcc-c++.x86_64 \
    mingw64-winpthreads-static.noarch \
    miniupnpc-devel \
    patch \
    python3 \
    qrencode-devel \
    qt5-qtbase-devel \
    qt5-qttools-devel \
    ripgrep \
    sqlite-devel \
    valgrind \
    vim \
    which \
    xz \
    zeromq-devel

RUN git clone https://github.com/bitcoin/bitcoin && mkdir bitcoin/depends/SDKs

RUN make download -C bitcoin/depends

RUN git clone https://github.com/bitcoin-core/bitcoin-maintainer-tools

# avoid git complaints
RUN git config --global pull.rebase false && \
    git config --global user.email "you@example.com" && \
    git config --global user.name "Your Name"

WORKDIR /bitcoin
