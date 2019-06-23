FROM alpine:3.10

ENV GUIX_VERSION 1.0.1
ENV PATH /root/.guix-profile/bin:$PATH

COPY . /bitcoin

RUN apk --no-cache --update add \
  bash \
  curl \
  make

RUN cd /tmp \
  && wget -q -O guix-binary-${GUIX_VERSION}.x86_64-linux.tar.xz ftp://ftp.gnu.org/gnu/guix/guix-binary-${GUIX_VERSION}.x86_64-linux.tar.xz \
  && echo "0b254610209fab571d7f4db156324cb541af2be354e74bf5391bedc79908583b  guix-binary-${GUIX_VERSION}.x86_64-linux.tar.xz" | sha256sum -c \
  && tar xJf guix-binary-${GUIX_VERSION}.x86_64-linux.tar.xz \
  && mv var/guix /var/ \
  && mv gnu /

RUN ln -sf /var/guix/profiles/per-user/root/current-guix ~root/.guix-profile

RUN guix archive --authorize < ~root/.guix-profile/share/guix/hydra.gnu.org.pub
RUN guix archive --authorize < ~root/.guix-profile/share/guix/ci.guix.info.pub

# Build Environment Setup
# https://www.gnu.org/software/guix/manual/en/html_node/Build-Environment-Setup.html#Build-Environment-Setup

RUN addgroup guixbuild

RUN for i in `seq -w 1 10`; \
  do \
    # user name
    adduser guix-builder$i \
    # Dont assign a password
    -D \
    # Group
    -G guixbuild \
    # home directory
    -h /var/empty \
    # login shell
    -s `which nologin`; \
  done

CMD guix-daemon --build-users-group=guixbuild
