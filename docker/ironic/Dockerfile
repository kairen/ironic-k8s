FROM alpine:3.6
MAINTAINER Kyle Bai (kyle.b@inwinstack.com)

RUN apk add --no-cache --update \
      python python-dev py-pip py-setuptools \
      build-base gcc jpeg-dev zlib-dev musl-dev \
      ca-certificates linux-headers qemu-img git \
      ipmitool postgresql-dev psmisc graphviz gettext \
      libffi-dev bash mysql-client && \
  pip install -U --no-cache-dir pip python-ironicclient pymysql tox virtualenv && \
  git clone https://github.com/openstack/ironic.git && \
  cd /ironic && \
  tox -egenconfig && \
  pip install -r requirements.txt && \
  pip install . && \
  mkdir -p /etc/ironic && \
  cp -r /ironic/etc/ironic/* /etc/ironic/ && \
  apk del gcc musl-dev linux-headers build-base && \
  pip uninstall -y tox virtualenv && \
  rm -rf /var/cache/apk/* && \
  rm -rf .tox/ && \
  rm -r /root/.cache

COPY boot.ipxe /etc/ironic/boot.ipxe
COPY scripts/* /usr/bin/

EXPOSE 6385 3260
ENTRYPOINT ["entrypoint.sh"]
