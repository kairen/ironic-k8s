# Install guide
(TBD)

### Pre-install
```sh
$ systemctl stop firewalld && systemctl disable firewalld
$ setenforce 0
$ yum install -y epel-release vim git
$ yum install -y python-pip python-devel libffi-devel gcc openssl-devel ansible ntp python-virtualenv python-netaddr screen
$ systemctl start ntpd && systemctl enable ntpd  
$ sudo pip install -U pip
$ curl -fsSL "https://get.docker.com/" | sh
$ systemctl start docker && systemctl enable docker
```

### Build and install ironic docker
```sh
$ git clone https://github.com/kairen/symmetrical-memory.git
$ cd symmetrical-memory/docker
$ ./00_build.sh
```

Edit config:
```bash
RABBITMQ_DEFAULT_USER=guest
RABBITMQ_DEFAULT_PASS=rabbit_secret

MYSQL_ROOT_PASSWORD=sql_secret
MYSQL_IRONIC_PASSWORD=ironic_secret

IPMI_INTERFACE=enp0s8
DATA_INTERFACE=enp0s9
IPMI_RANGE=192.168.20.10,192.168.20.20,12h
DATA_RANGE=192.168.30.10,192.168.30.20,12h
BOOT_IPXE_ENDPOINT=http://192.168.30.6:8080/boot.ipxe
DNSMASQ_ADDITIONAL="dhcp-host=0c:c4:7a:ca:3a:3e,192.168.20.11 \
dhcp-host=0c:c4:7a:ca:3a:4b,192.168.20.12 \
dhcp-host=0c:c4:7a:9a:3c:64,192.168.20.13"

IRONIC_DEBUG=false
```

Install:
```sh
$ ./install.sh
```

### Build base images
```sh
$ ./dib.sh

# Into container
$ cd imagedata/httpboot/
$ cat <<EOF > k8s.repo
[kubernetes]
name=Kubernetes
baseurl=http://yum.kubernetes.io/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

$ DIB_YUM_REPO_CONF=k8s.repo \
DIB_DEV_USER_USERNAME=kyle \
DIB_DEV_USER_PWDLESS_SUDO=true \
DIB_DEV_USER_AUTHORIZED_KEYS=/id_rsa.pub \
disk-image-create \
            centos7 \
            dhcp-all-interfaces \
            devuser \
            yum \
            epel \
            baremetal \
            -o k8s.qcow2 \
            -p vim,docker,kubelet,kubeadm,kubectl,kubernetes-cni
```

## ironic node
```sh
$  virtualenv .ironic
$ source .ironic/bin/activate
(.ironic)$ pip install -U pip
(.ironic)$ pip install python-ironicclient

# IPMI node
$ ipmitool -U admin -P admin -H 192.168.0.100 chassis power status
$ ironic node-create -d agent_ipmitool \
                     -n node1 \
                     -u 00000000-0000-0000-0000-000000000001 \
                     -i ipmi_address=192.168.0.100 \
                     -i ipmi_username=admin \
                     -i ipmi_password=admin
# option-1
$ ironic node-update node1 add driver_info/deploy_ramdisk=http://192.168.20.6:8080/ipa.initramfs \
                               driver_info/deploy_kernel=http://192.168.20.6:8080/ipa.vmlinuz \
                               properties/cpus=1 \
                               properties/member_mb=1024 \
                               properties/local_gb=10 \
                               properties/cpu_arch=x86_64 \
                               instance_info/ramdisk=http://192.168.20.6:8080/k8s.initrd \
                               instance_info/kernel=http://192.168.20.6:8080/k8s.vmlinuz \
                               instance_info/image_source=http://192.168.20.6:8080/k8s.qcow2 \
                               instance_info/image_checksum=21fc409ba41956b0d53a0f370216c18f \
                               instance_info/root_gb=10

# option-2                
$ ironic node-update node1 add driver_info/ipmi_username=admin \
                               driver_info/ipmi_address=192.168.0.100 \
                               driver_info/ipmi_password=admin \
                               driver_info/deploy_ramdisk=http://192.168.20.6:8080/ipa.initramfs \
                               driver_info/deploy_kernel=http://192.168.20.6:8080/ipa.vmlinuz \
                               properties/cpus=1 \
                               properties/member_mb=1024 \
                               properties/local_gb=10 \
                               properties/cpu_arch=x86_64 \
                               instance_info/ramdisk=http://192.168.20.6:8080/k8s.initrd \
                               instance_info/kernel=http://192.168.20.6:8080/k8s.vmlinuz \
                               instance_info/image_source=http://192.168.20.6:8080/k8s.qcow2 \
                               instance_info/image_checksum=21fc409ba41956b0d53a0f370216c18f \
                               instance_info/root_gb=10

$ ironic port-create -n 00000000-0000-0000-0000-000000000001 -a 0c:c4:7a:ca:3b:2c
$ ironic port-create -n 00000000-0000-0000-0000-000000000001 -a 0c:c4:7a:ca:3b:2d
```
