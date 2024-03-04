FROM debian:bullseye-slim

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
	automake \
	bsdmainutils \
	bzip2 \
	ca-certificates \
	clang-11 \
	curl \
	gcc \
	g++ \
	git \
	lbzip2 \
	libtool \
	libboost-dev \
	make \
	pkg-config \
	vim

RUN git clone https://github.com/bitcoin/bitcoin && \
	git clone https://github.com/bitcoin-core/qa-assets

RUN make download -C bitcoin/depends NO_QT=1 NO_ZMQ=1 NO_UPNP=1 NO_WALLET=1