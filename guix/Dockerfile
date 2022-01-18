FROM alpine:3.15

RUN apk --no-cache --update add \
      bash \
      bzip2 \
      ca-certificates \
      curl \
      git \
      make \
      shadow

ARG guix_download_path=ftp://ftp.gnu.org/gnu/guix
ARG guix_version=1.3.0
ARG guix_checksum_aarch64=444f6536cf5959636123ac718db9b85071502e485555b2d801bf2936930810ce
ARG guix_checksum_x86_64=c5f7efb48947545e49d2daf48d0f832f35d2a8d19f65daaf6079425ac327c050
ARG builder_count=32

ENV PATH /root/.config/guix/current/bin:$PATH
ENV LOCPATH /root/.config/guix/current/lib/locale

RUN guix_file_name=guix-binary-${guix_version}.$(uname -m)-linux.tar.xz    && \
    eval "guix_checksum=\${guix_checksum_$(uname -m)}"                     && \
    cd /tmp                                                                && \
    wget -q -O "$guix_file_name" "${guix_download_path}/${guix_file_name}" && \
    echo "${guix_checksum}  ${guix_file_name}" | sha256sum -c              && \
    tar xJf "$guix_file_name"                                              && \
    mv var/guix /var/                                                      && \
    mv gnu /                                                               && \
    mkdir -p ~root/.config/guix                                            && \
    ln -sf /var/guix/profiles/per-user/root/current-guix ~root/.config/guix/current && \
    source ~root/.config/guix/current/etc/profile

# Guix expects this file to exist
RUN touch /etc/nsswitch.conf

RUN guix archive --authorize < ~root/.config/guix/current/share/guix/ci.guix.gnu.org.pub

# Build Environment Setup
# https://guix.gnu.org/manual/en/html_node/Build-Environment-Setup.html#Build-Environment-Setup

RUN groupadd --system guixbuild
RUN for i in $(seq -w 1 ${builder_count}); do    \
      useradd -g guixbuild -G guixbuild          \
              -d /var/empty -s $(which nologin)  \
              -c "Guix build user ${i}" --system \
              "guixbuilder${i}" ;                \
    done

CMD ["/root/.config/guix/current/bin/guix-daemon","--build-users-group=guixbuild"]

RUN git clone https://github.com/bitcoin/bitcoin.git /bitcoin

WORKDIR /bitcoin
