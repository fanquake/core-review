FROM gentoo/stage3:arm64-musl-hardened

RUN emerge-webrsync && emerge --sync && emerge \
    boost \
    ccache \
    cmake \
    dev-vcs/git \
    libevent \
    vim

RUN git clone https://github.com/bitcoin/bitcoin && mkdir bitcoin/depends/SDKs

RUN make download -C bitcoin/depends
