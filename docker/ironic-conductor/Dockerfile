FROM kairen/ironic-base
MAINTAINER Kyle Bai (kyle.b@inwinstack.com)

RUN yum install -y qemu-img
COPY entrypoint.sh /usr/bin/entrypoint.sh

EXPOSE 3260
ENTRYPOINT ["entrypoint.sh"]
