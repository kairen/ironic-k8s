#!/bin/bash
#
# Create k8s base image.
#

set -e
cd /imagedata/httpboot/

cat <<EOF > k8s.repo
[kubernetes]
name=Kubernetes
baseurl=http://yum.kubernetes.io/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Create image
DIB_YUM_REPO_CONF=k8s.repo \
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

# Create md5 sum
md5sum k8s.qcow2
