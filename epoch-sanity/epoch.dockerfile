FROM ubuntu:22.10

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
    autoconf \
    automake \
    bsdmainutils \
    bzip2 \
    ca-certificates \
    g++-12 \
    cmake \
    curl \
    git \
    libboost-dev \
    libevent-dev \
    libtool \
    make \
    patch \
    pkg-config \
    python3 \
    vim

RUN git clone https://github.com/bitcoin/bitcoin/

RUN make download-linux -C bitcoin/depends NO_WALLET=1 NO_QT=1 NO_ZMQ=1 NO_NATPMP=1 NO_UPNP=1

RUN git clone --depth=1 https://github.com/llvm/llvm-project

RUN cd /llvm-project && \
    cmake -S . -B build \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=gcc-12 \
    -DCMAKE_CXX_COMPILER=g++-12 \
    -DLLVM_ENABLE_PROJECTS='clang' \
    -DLLVM_ENABLE_RUNTIMES='compiler-rt;libcxx;libcxxabi' \
    -DLLVM_TARGETS_TO_BUILD='AArch64' \
    llvm/ && \
    cmake --build build --target install -j9

WORKDIR /bitcoin/