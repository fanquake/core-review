FROM debian:bullseye

RUN echo 'Acquire::HTTP::Proxy "http://172.17.0.1:3142";' >> /etc/apt/apt.conf.d/01proxy \
 && echo 'Acquire::HTTPS::Proxy "false";' >> /etc/apt/apt.conf.d/01proxy

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
    automake \
    binutils \
    bison \
    bzip2 \
    ca-certificates \
    clang \
    cmake \
    curl \
    diffoscope \
    g++ \
    gcc \
    gdb \
    git \
    libtool \
    man \
    make \
    patch \
    pkg-config \
    python3 \
    unzip \
    valgrind \
    vim \
    wget \
    xz-utils

RUN git clone https://github.com/bitcoin/bitcoin

RUN make download -C bitcoin/depends

RUN cd bitcoin && \
    git config --global pull.rebase false && \
    git config --global user.email "you@example.com" && \
    git config --global user.name "Your Name" && \
    git remote add fanquake https://github.com/fanquake/bitcoin.git
