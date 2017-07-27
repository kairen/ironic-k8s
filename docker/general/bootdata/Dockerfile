FROM alpine:3.6
MAINTAINER Kyle Bai (kyle.b@inwinstack.com)

RUN mkdir /data && \
  mkdir /data/tmp && \
  mkdir /data/cache && \
  mkdir /data/httpboot && \
  mkdir /data/httpboot/pxelinux.cfg && \
  mkdir /data/httpboot/master_images && \
  mkdir /data/tftpboot && \
  mkdir /data/tftpboot/pxelinux.cfg && \
  mkdir /data/tftpboot/master_images

COPY httpboot/ /data/httpboot
COPY tftpboot/ /data/tftpboot
COPY entrypoint.sh /usr/bin/

ENTRYPOINT ["entrypoint.sh"]
