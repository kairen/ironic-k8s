FROM kairen/ironic-base
MAINTAINER Kyle Bai (kyle.b@inwinstack.com)

RUN yum install -y mariadb
COPY entrypoint.sh /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
