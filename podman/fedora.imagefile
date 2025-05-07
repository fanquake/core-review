FROM fedora:41

RUN dnf update -y && dnf install --setopt=install_weak_deps=False -y \
    bison \
    boost-devel \
    bzip2 \
    cmake \
    gcc-c++ \
    git \
    libevent-devel \
    make \
    mingw64-gcc-c++ \
    mingw64-winpthreads-static \
    patch \
    python3 \
    qrencode-devel \
    qt5-qtbase-devel \
    qt5-qttools-devel \
    sqlite-devel \
    which \
    xz \
    zeromq-devel

RUN git clone https://github.com/bitcoin/bitcoin && mkdir bitcoin/depends/SDKs

RUN make download -C bitcoin/depends

# avoid git complaints
RUN git config --global pull.rebase false && \
    git config --global user.email "you@example.com" && \
    git config --global user.name "Your Name"

WORKDIR /bitcoin
