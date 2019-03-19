FROM gliderlabs/alpine:3.9

ENV GUIX_VERSION 0.16.0
ENV PATH /root/.guix-profile/bin:$PATH

RUN apk --no-cache --update add bash \
  curl \
  file \
  make \
  patchelf \
  sudo

RUN cd /tmp \
  && wget -qO- ftp://alpha.gnu.org/gnu/guix/guix-binary-${GUIX_VERSION}.x86_64-linux.tar.xz \
  | tar xJf - \
  && mv var/guix /var/ \
  && mv gnu /

RUN ln -sf /var/guix/profiles/per-user/root/current-guix ~root/.guix-profile

RUN guix archive --authorize < ~root/.guix-profile/share/guix/hydra.gnu.org.pub
RUN guix archive --authorize < ~root/.guix-profile/share/guix/ci.guix.info.pub

RUN addgroup guixbuild
RUN addgroup guix-builder
RUN chgrp guix-builder -R /gnu/store
RUN chmod 1775 /gnu/store

RUN for i in `seq -w 1 10` ; do \
    adduser -S guix-builder$i guix-builder ;\
    adduser guix-builder$i guix-builder ;\
  done

CMD guix-daemon --build-users-group=guix-builder
