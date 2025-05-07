FROM centos:8

# centos 8 doesn't have a miniupnpc dev package
# powertools required for qrencode-devel
RUN dnf -y install dnf-plugins-core \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    dnf config-manager --set-enabled powertools && \
    dnf -y install \
    autoconf \
    automake \
    bison \
    boost-devel \
    bzip2 \
    cmake \
    curl \
    dnf-plugins-core \
    file \
    gcc-c++ \
    git \
    libevent-devel \
    libnatpmp-devel \
    libtool \
    libupnp-devel \
    make \
    patch \
    pkgconfig \
    python3 \
    qrencode-devel \
    qt5-qtbase-devel \
    qt5-qttools-devel \
    valgrind-devel \
    which \
    zeromq-devel

RUN git clone https://github.com/bitcoin/bitcoin && mkdir bitcoin/depends/SDKs

RUN make download -C bitcoin/depends

RUN git clone https://github.com/bitcoin-core/bitcoin-maintainer-tools

WORKDIR /bitcoin
