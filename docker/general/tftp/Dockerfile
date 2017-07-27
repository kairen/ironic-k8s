FROM alpine:3.6
MAINTAINER Kyle Bai (kyle.b@inwinstack.com)

RUN apk add --no-cache --update tftp-hpa && \
  rm -rf /var/cache/apk/*

COPY entrypoint.sh /usr/bin

EXPOSE 69 69/udp
ENTRYPOINT ["entrypoint.sh"]
