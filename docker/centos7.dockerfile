FROM centos:7

RUN yum -y update && yum -y install \
    autoconf \
    automake \
    bzip2 \
    cmake \
    curl \
    gcc-c++ \
    git \
    libtool \
    make \
    patch \
    pkgconfig \
    python3

RUN git clone https://github.com/bitcoin/bitcoin && mkdir bitcoin/depends/SDKs

RUN make download -C bitcoin/depends

RUN git clone https://github.com/bitcoin-core/bitcoin-maintainer-tools