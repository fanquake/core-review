FROM debian:bullseye

RUN echo 'Acquire::HTTP::Proxy "http://172.17.0.1:3142";' >> /etc/apt/apt.conf.d/01proxy \
 && echo 'Acquire::HTTPS::Proxy "false";' >> /etc/apt/apt.conf.d/01proxy

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
    automake \
    binutils \
    bzip2 \
    ca-certificates \
    clang-10 \
    cmake \
    curl \
    diffoscope \
    g++-10 \
    gcc-10 \
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

RUN update-alternatives --install /usr/bin/clang clang $(which clang-10) 100 && \
    update-alternatives --install /usr/bin/clang++ clang++ $(which clang++-10) 100

RUN update-alternatives --install /usr/bin/gcc gcc $(which gcc-10) 100 && \
    update-alternatives --install /usr/bin/g++ g++ $(which g++-10) 100

RUN git clone https://github.com/bitcoin/bitcoin

RUN make download -C bitcoin/depends

RUN cd bitcoin && \
    git config --global pull.rebase false && \
    git remote add fanquake https://github.com/fanquake/bitcoin.git