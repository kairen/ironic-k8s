#!/bin/bash
#
# Create a ironic node.
#

NODE_NAME="node1"
IPMI_IP="172.20.50.12" # infra-ecosphere bind IP
IPMI_USERNAME="admin"
IPMI_PASSWD="admin"

IMAGE_CHECKSUM="acd434942930e9947b90eddf78b75138"
NODE_MAC="08:00:27:8D:4B:D8"

ironic node-create \
  -d agent_ipmitool \
  -n ${NODE_NAME} \
  -i ipmi_address=${IPMI_IP} \
  -i ipmi_username=${IPMI_USERNAME} \
  -i ipmi_password=${IPMI_PASSWD}
  -i ipmi_protocol_version=1.5

UUID=$(ironic node-show ${NODE_NAME} | grep "| uuid" | awk '{print $4}')

ironic node-update ${NODE_NAME} add \
  driver_info/deploy_ramdisk=http://192.168.30.6:8080/ipa.initramfs \
  driver_info/deploy_kernel=http://192.168.30.6:8080/ipa.vmlinuz \
  properties/cpus=1 \
  properties/member_mb=1024 \
  properties/local_gb=10 \
  properties/cpu_arch=x86_64 \
  instance_info/ramdisk=http://192.168.30.6:8080/k8s.initrd \
  instance_info/kernel=http://192.168.30.6:8080/k8s.vmlinuz \
  instance_info/image_source=http://192.168.30.6:8080/k8s.qcow2 \
  instance_info/image_checksum=${IMAGE_CHECKSUM} \
  instance_info/root_gb=10

ironic port-create -n ${UUID} -a ${NODE_MAC}
ironic node-validate ${NODE_NAME}
ironic node-set-provision-state ${NODE_NAME} active
