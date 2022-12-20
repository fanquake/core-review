FROM debian:bookworm-slim

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
    automake \
    binutils \
    bsdmainutils \
    ca-certificates \
    cmake \
    curl \
    diffoscope \
    doxygen \
    git \
    libbz2-dev \
    libcap-dev \
    libtinfo5 \
    libtool \
    lbzip2 \
    libz-dev \
    make \
    nsis \
    patch \
    pkg-config \
    python3 \
    python3-setuptools \
    ripgrep \
    vim \
    xz-utils
# Split cross-compilers out.
# apt cant install everything at once
RUN apt-get install --no-install-recommends -y \
    g++-aarch64-linux-gnu \
    binutils-aarch64-linux-gnu \
    g++-arm-linux-gnueabihf \
    binutils-arm-linux-gnueabihf \
    binutils-riscv64-linux-gnu \
    g++-riscv64-linux-gnu \
    g++-mingw-w64-x86-64-posix

RUN git clone https://github.com/bitcoin/bitcoin && mkdir bitcoin/depends/SDKs

RUN make download -C bitcoin/depends

RUN git clone https://github.com/bitcoin-core/bitcoin-maintainer-tools

WORKDIR /bitcoin
