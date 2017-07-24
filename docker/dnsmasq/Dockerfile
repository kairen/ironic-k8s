FROM alpine:3.4
MAINTAINER Kyle Bai (kyle.b@inwinstack.com)

RUN apk --no-cache add dnsmasq && \
  rm -f /var/cache/apk/*
  
COPY scripts/* /usr/bin/

EXPOSE 53 53/udp
ENTRYPOINT ["entrypoint.sh"]
