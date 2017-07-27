#!/bin/bash
#
# Build docker images.
#

IMAGE_USER=${IMAGE_USER:-"kairen"}
IMAGES="dnsmasq image-builder tftp bootdata httpd"

set -e

for image in ${IMAGES}; do
  echo -e "\033[34m*** Build ${image} ***\033[0m"
  docker build -t ${IMAGE_USER}/${image} ${image}/.
done
