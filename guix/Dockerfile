FROM alpine:3.14

RUN apk --no-cache --update add \
      bash \
      curl \
      make \
      shadow \
      git \
      ca-certificates

ARG guix_download_path=ftp://ftp.gnu.org/gnu/guix
ARG guix_version=1.3.0
ARG guix_checksum_aarch64=444f6536cf5959636123ac718db9b85071502e485555b2d801bf2936930810ce
ARG guix_checksum_x86_64=c5f7efb48947545e49d2daf48d0f832f35d2a8d19f65daaf6079425ac327c050
ARG builder_count=32

RUN guix_file_name=guix-binary-${guix_version}.$(uname -m)-linux.tar.xz    && \
    eval "guix_checksum=\${guix_checksum_$(uname -m)}"                     && \
    cd /tmp                                                                && \
    wget -q -O "$guix_file_name" "${guix_download_path}/${guix_file_name}" && \
    echo "${guix_checksum}  ${guix_file_name}" | sha256sum -c              && \
    tar xJf "$guix_file_name"                                              && \
    mv var/guix /var/                                                      && \
    mv gnu /

RUN ln -sf /var/guix/profiles/per-user/root/current-guix /root/.guix-profile
ENV PATH /root/.guix-profile/bin:$PATH

RUN guix archive --authorize < ~root/.guix-profile/share/guix/ci.guix.info.pub
RUN wget -qO- "https://guix.carldong.io/signing-key.pub" | guix archive --authorize

# Build Environment Setup
# https://guix.gnu.org/manual/en/html_node/Build-Environment-Setup.html#Build-Environment-Setup

RUN groupadd --system guixbuild
RUN for i in $(seq -w 1 ${builder_count}); do    \
      useradd -g guixbuild -G guixbuild          \
              -d /var/empty -s $(which nologin)  \
              -c "Guix build user ${i}" --system \
              "guixbuilder${i}" ;                \
    done

CMD guix-daemon \
      --build-users-group=guixbuild   \
      --substitute-urls="https://guix.carldong.io https://ci.guix.gnu.org"

RUN git clone https://github.com/bitcoin/bitcoin.git /bitcoin

WORKDIR /bitcoin
