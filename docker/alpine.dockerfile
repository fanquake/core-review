FROM alpine:3.16

# linux-headers for futex.h in Qt depends build
# qt5-qttools-dev for lrelease
RUN apk --no-cache --update add \
    autoconf \
    automake \
    bison \
    boost-dev \
    cmake \
    curl \
    g++ \
    gcc \
    git \
    libevent-dev \
    libqrencode-dev \
    libtool \
    linux-headers \
    make \
    mingw-w64-gcc \
    miniupnpc-dev \
    patch \
    perl \
    pkgconfig \
    python3 \
    qt5-qtbase-dev \
    qt5-qttools-dev \
    sqlite \
    valgrind \
    vim \
    zeromq-dev

RUN git clone https://github.com/bitcoin/bitcoin && mkdir bitcoin/depends/SDKs

RUN make download -C bitcoin/depends

RUN git clone https://github.com/bitcoin-core/bitcoin-maintainer-tools

# avoid git complaints
RUN git config --global pull.rebase false && \
    git config --global user.email "you@example.com" && \
    git config --global user.name "Your Name"

WORKDIR /bitcoin
