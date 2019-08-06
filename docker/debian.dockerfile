FROM debian:buster-slim

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
    automake \
    binutils \
    bsdmainutils \
    ca-certificates \
    cmake \
    curl \
    diffoscope \
    g++-multilib \
    git \
    libtool \
    lbzip2 \
    make \
    patch \
    pkg-config \
    python3 \
    rsync \
    xz-utils
# Split cross compile dependencies out.
# apt cant seem to install everything at once
RUN apt-get install --no-install-recommends -y \
    imagemagick \
    libbz2-dev \
    libcap-dev \
    librsvg2-bin \
    libtiff-tools \
    libtinfo5 \
    libz-dev \
    python3-setuptools \
    g++-aarch64-linux-gnu \
    binutils-aarch64-linux-gnu \
    g++-arm-linux-gnueabihf \
    binutils-arm-linux-gnueabihf \
    binutils-riscv64-linux-gnu \
    g++-riscv64-linux-gnu \
    g++-mingw-w64-x86-64

RUN git clone https://github.com/bitcoin/bitcoin && mkdir bitcoin/depends/SDKs

RUN make download -C bitcoin/depends

RUN git clone https://github.com/bitcoin-core/bitcoin-maintainer-tools

# https://github.com/bitcoin/bitcoin/blob/master/doc/build-windows.md#footnotes
RUN update-alternatives --set x86_64-w64-mingw32-g++ /usr/bin/x86_64-w64-mingw32-g++-posix
