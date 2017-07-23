FROM alpine:3.4
MAINTAINER Kyle Bai (kyle.b@inwinstack.com)

COPY scripts/* /usr/bin/
RUN apk --no-cache add dnsmasq && \
  rm -f /var/cache/apk/*

EXPOSE 53 53/udp
ENTRYPOINT ["entrypoint.sh"]
