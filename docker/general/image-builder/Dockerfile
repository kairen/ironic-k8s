FROM alpine:3.6
MAINTAINER Kyle Bai (kyle.b@inwinstack.com)

RUN apk add --no-cache --update \
      git py-pip which qemu-img sudo e2fsprogs bash && \
  pip install -U diskimage-builder && \
  rm -rf /var/cache/apk/* && \
  rm -r /root/.cache

COPY create-k8s-image.sh /usr/bin/create-k8s-image

CMD ["/bin/bash"]
