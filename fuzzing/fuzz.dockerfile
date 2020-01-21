FROM debian:bullseye-slim

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
	automake \
	bsdmainutils \
	ca-certificates \
	clang-9 \
	curl \
	g++ \
	git \
	lbzip2 \
	libtool \
	make \
	pkg-config \
	vim

RUN git clone https://github.com/bitcoin/bitcoin && \
	git clone https://github.com/bitcoin-core/qa-assets

RUN make download -C bitcoin/depends NO_QT=1 NO_ZMQ=1 NO_UPNP=1 NO_WALLET=1