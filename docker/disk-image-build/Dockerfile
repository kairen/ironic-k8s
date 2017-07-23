FROM centos:7
MAINTAINER Kyle Bai (kyle.b@inwinstack.com)

RUN yum install -y epel-release && \
  yum install -y git python-pip which qemu-img sudo e2fsprogs && \
  pip install -U diskimage-builder && \
  yum clean all

COPY create-k8s-image.sh /usr/bin/create-k8s-image

CMD ["/bin/bash"]
