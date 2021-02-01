FROM alpine:3.13

# linux-headers for futex.h in Qt depends build
RUN apk --no-cache --update add \
    autoconf \
    automake \
    cmake \
    curl \
    g++ \
    gcc \
    git \
    libtool \
    linux-headers \
    make \
    mingw-w64-gcc \
    patch \
    perl \
    pkgconfig \
    python3

RUN git clone https://github.com/bitcoin/bitcoin && mkdir bitcoin/depends/SDKs

RUN make download -C bitcoin/depends

RUN git clone https://github.com/bitcoin-core/bitcoin-maintainer-tools
