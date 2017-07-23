FROM centos:7
MAINTAINER Kyle Bai (kyle.b@inwinstack.com)

RUN yum install -y tftp-server xinetd
COPY entrypoint.sh /usr/bin

EXPOSE 69 69/udp
ENTRYPOINT ["entrypoint.sh"]
