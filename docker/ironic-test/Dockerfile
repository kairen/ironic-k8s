FROM kairen/ironic-base
MAINTAINER Kyle Bai (kyle.b@inwinstack.com)

RUN yum install -y mariadb
COPY check_rabbit.py /usr/bin/check_rabbit.py

ENTRYPOINT ["/bin/bash"]
