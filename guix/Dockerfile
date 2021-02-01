FROM alpine:3.13

RUN apk --no-cache --update add \
  bash \
  curl \
  make \
  shadow \
  git \
  ca-certificates

ARG guix_download_path=ftp://ftp.gnu.org/gnu/guix/
ARG guix_file_name=guix-binary-1.2.0.x86_64-linux.tar.xz
ARG guix_checksum=58fecdbaa8bec3795930879fad4cf7c31d3291c363b6cced18e4f7008d7e0282

RUN git clone https://github.com/bitcoin/bitcoin.git /bitcoin \
  && cd /tmp \
  && wget -q -O "$guix_file_name" "${guix_download_path}/${guix_file_name}" \
  && echo "${guix_checksum}  ${guix_file_name}" | sha256sum -c \
  && tar xJf "$guix_file_name" \
  && mv var/guix /var/ \
  && mv gnu /

WORKDIR /bitcoin

RUN ln -sf /var/guix/profiles/per-user/root/current-guix /root/.guix-profile
ENV PATH /root/.guix-profile/bin:$PATH

RUN guix archive --authorize < ~root/.guix-profile/share/guix/ci.guix.info.pub
RUN wget -qO- "https://guix.carldong.io/signing-key.pub" | guix archive --authorize

# Build Environment Setup
# https://guix.gnu.org/manual/en/html_node/Build-Environment-Setup.html#Build-Environment-Setup

RUN addgroup guixbuild
RUN for i in $(seq -w 1 32);                    \
  do                                            \
    useradd -g guixbuild -G guixbuild           \
            -d /var/empty -s "$(which nologin)" \
            -c "Guix build user ${i}" --system  \
          "guixbuilder${i}";                    \
  done

CMD guix-daemon --build-users-group=guixbuild   \
                --substitute-urls="https://guix.carldong.io https://ci.guix.gnu.org"
