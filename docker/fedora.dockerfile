FROM fedora:29

COPY . /bitcoin

RUN dnf update -y && dnf install -y \
    autoconf \
    automake \
    bzip2 \
    cmake \
    gcc-c++ \
    git \
    libtool \
    make \
    patch \
    python3 \
    which \
    xz

RUN cd bitcoin && git clean -fxd
