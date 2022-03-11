FROM gentoo/stage3:amd64-musl-hardened

RUN emerge-webrsync && emerge --sync && emerge \
    boost \
    dev-vcs/git \
    libevent \
    net-libs/miniupnpc \
    sys-apps/ripgrep \
    zeromq

RUN git clone https://github.com/bitcoin/bitcoin && mkdir bitcoin/depends/SDKs

RUN make download -C bitcoin/depends

RUN git clone https://github.com/bitcoin-core/bitcoin-maintainer-tools
