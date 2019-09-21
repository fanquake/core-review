FROM alpine:3.10

RUN apk --no-cache --update add \
    autoconf \
    automake \
    cmake \
    curl \
    g++ \
    gcc \
    git \
    libtool \
    make \
    perl \
    pkgconfig \
    python3


RUN git clone https://github.com/bitcoin/bitcoin && mkdir bitcoin/depends/SDKs

RUN make download -C bitcoin/depends

RUN git clone https://github.com/bitcoin-core/bitcoin-maintainer-tools
