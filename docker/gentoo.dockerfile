FROM gentoo:stage3-amd64

RUN emerge-webrsync && emerge --sync && emerge boost \
    dev-vcs/git \
    libevent \
    net-libs/miniupnpc \
    zeromq

RUN git clone https://github.com/bitcoin/bitcoin && mkdir bitcoin/depends/SDKs
