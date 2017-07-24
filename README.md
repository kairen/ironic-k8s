[![Build Status](https://travis-ci.org/kairen/ironic-k8s-dev.svg?branch=master)](https://travis-ci.org/kairen/ironic-k8s-dev)
# Deploy Kubernetes Using OpenStack Ironic
Setup a containerize Ironic environment, and deploy Kubernetes using Ironic.

Requirements:
* GNU make
* Docker

Install Docker engine:
```sh
$ curl -fsSL "https://get.docker.com/" | sh
```

## Usage
In order to create the ironic service on `Ubuntu16` or `Centos7` as follows step.

### Deploy Ironic service
Download this repository via git:
```sh
$ git clone https://github.com/kairen/ironic-k8s-dev.git
$ cd ironic-k8s-dev/docker
```

Build standable ironic containers:
```sh
$ make build
```

Edit `config.env` file:
```sh
# Host ip address
HOST_IP=172.22.132.93

# RabbitMQ credentials
RABBITMQ_DEFAULT_USER=guest
RABBITMQ_DEFAULT_PASS=rabbit_secret

# MariaDB credentials
MYSQL_ROOT_PASSWORD=sql_secret
MYSQL_IRONIC_PASSWORD=ironic_secret

# dnsmasq settings
IPMI_INTERFACE=enp6s0
DATA_INTERFACE=enp7s0
IPMI_RANGE=172.20.3.10,172.20.3.100,12h
DATA_RANGE=172.22.132.10,172.22.132.100,12h
BOOT_IPXE_ENDPOINT="http://${HOST_IP}:8080/boot.ipxe"

# Ironic Settings
IRONIC_DEBUG=false
```

To run the ironic service:
```sh
$ make deploy
```

(option)To reset the ironic service:
```sh
$ make reset
```

### Create boot image
To build the OS images:
```sh
$ ssh-keygen -t rsa
$ cd ironic-k8s-dev/docker
$ make dib
root@daq31-ca314# create-k8s-image
```

### Add a baremetal node
To boot a node use:
```sh
$  virtualenv .ironic
$ source .ironic/bin/activate
(.ironic)$ pip install -U pip
(.ironic)$ pip install python-ironicclient

# (.ironic)
$ ironic node-create -d agent_ipmitool \
                     -n ironic-bare \
                     -i ipmi_address=172.20.3.194 \
                     -i ipmi_username=maas \
                     -i ipmi_password=NCCflzyX349iJ

$ ironic node-update ironic-bare add driver_info/deploy_ramdisk=http://172.22.132.93:8080/ipa.initramfs \
                               driver_info/deploy_kernel=http://172.22.132.93:8080/ipa.vmlinuz \
                               properties/cpus=4 \
                               properties/member_mb=16384 \
                               properties/local_gb=100 \
                               properties/cpu_arch=x86_64 \
                               instance_info/ramdisk=http://172.22.132.93:8080/k8s.initrd \
                               instance_info/kernel=http://172.22.132.93:8080/k8s.vmlinuz \
                               instance_info/image_source=http://172.22.132.93:8080/k8s.qcow2 \
                               instance_info/image_checksum=<IMAGE_MD5_CHECKSUM> \
                               instance_info/root_gb=100

$ ironic port-create -n <NODE_UUID> -a <NODE_ETH_MAC>
$ ironic node-validate ironic-bare
$ ironic node-set-provision-state ironic-bare active
```
> To test the IPMI of node:
```sh
$ ipmitool -U <USER> -P <PASSWD> -H <HOST_IP> chassis power status
```
