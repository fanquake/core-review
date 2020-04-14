FROM debian:bullseye

RUN echo 'Acquire::HTTP::Proxy "http://172.17.0.1:3142";' >> /etc/apt/apt.conf.d/01proxy \
 && echo 'Acquire::HTTPS::Proxy "false";' >> /etc/apt/apt.conf.d/01proxy

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
	binutils \
	ca-certificates \
	clang \
    curl \
    diffoscope \
    gcc \
    git \
    man \
    make \
    vim

RUN git clone https://github.com/bitcoin/bitcoin