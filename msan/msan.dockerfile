FROM ubuntu:22.10

COPY exclude.txt .

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
    libtool \
    make \
    mold \
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
    -DCMAKE_INSTALL_PREFIX=/installed \
    -DLLVM_ENABLE_PROJECTS='clang' \
    -DLLVM_ENABLE_RUNTIMES='compiler-rt;libcxx;libcxxabi' \
    -DLLVM_TARGETS_TO_BUILD='AArch64' \
    -DLLVM_USE_LINKER=mold \
    llvm/ && \
    cmake --build build --target install -j9

ENV LIBCXX_DIR /installed/
ENV MSAN_FLAGS "-fsanitize=memory -fsanitize-memory-track-origins=2 -fno-omit-frame-pointer -fno-optimize-sibling-calls"
ENV LIBCXX_FLAGS "-nostdinc++ -stdlib=libc++ -L${LIBCXX_DIR}lib -L${LIBCXX_DIR}lib/aarch64-unknown-linux-gnu -lc++abi -I${LIBCXX_DIR}include/c++/v1 -I${LIBCXX_DIR}include/aarch64-unknown-linux-gnu/c++/v1 -lpthread -Wl,-rpath,${LIBCXX_DIR}lib/ -Wl,-rpath,${LIBCXX_DIR}lib/aarch64-unknown-linux-gnu"
ENV MSAN_AND_LIBCXX_FLAGS "${MSAN_FLAGS} ${LIBCXX_FLAGS} -g -O1 -Wno-unused-command-line-argument"

RUN update-alternatives --install /usr/bin/clang clang /installed/bin/clang 100
RUN update-alternatives --install /usr/bin/clang++ clang++ /installed/bin/clang++ 100

WORKDIR /bitcoin/