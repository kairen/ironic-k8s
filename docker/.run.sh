#!/bin/bash
#
# Run all container.
#

CONF="./config"
USER="kairen"
IMAGE_VOLUME="image"

function status {
  echo -e "\033[34mStart ${1} ...\033[0m"
}

set -e

## start rabbitmq
status rabbitmq
docker run -d \
    --env-file ${CONF} \
    --hostname rabbitmq \
    --name rabbitmq \
    rabbitmq:3

## start mariadb
status mariadb
docker volume create --name db
docker run -d \
    -v db:/var/lib/mysql \
    --env-file ${CONF} \
    --hostname mariadb \
    --name mariadb \
    mariadb:10.1.22

## start copy image data
status imagedata
docker volume create --name ${IMAGE_VOLUME}
docker run -v image:/imagedata \
    -it --rm \
    --name boot-image \
    ${USER}/boot-image

## start tftp
status tftp
docker run -d -p 69:69/udp \
    -v ${IMAGE_VOLUME}:/imagedata \
    --name tftp \
    ${USER}/tftp

## start httpd
status httpd
docker run -d --rm -p 8080:80 \
    -v ${IMAGE_VOLUME}:/imagedata \
    --name httpd \
    ${USER}/httpd

## start dnsmasq
status dnsmasq
source ./config
docker run -d --rm -p 53:53 -p 53:53/udp \
    --env-file ${CONF}  \
    --cap-add=NET_ADMIN \
    --net=host \
    -v $PWD/dnsmasq.conf:/etc/dnsmasq.d/ip_assignment.conf \
    --name dnsmasq \
    ${USER}/dnsmasq

## start ironic db sync
status sync-db
docker run --rm \
    --env-file ${CONF}  \
    --link=rabbitmq:rabbitmq \
    --link=mariadb:mariadb \
    --name ironic-dbsync \
    ${USER}/ironic-dbsync

## start ironic api
status ironic-api
docker run -d -p 6385:6385 \
    --env-file ${CONF} \
    --link=rabbitmq:rabbitmq \
    --link=mariadb:mariadb \
    --name ironic-api \
    ${USER}/ironic-api

## start ironic conductor
status ironic-conductor
docker run -d -p 3260:3260 \
    --env-file ${CONF} \
    --link=rabbitmq:rabbitmq \
    --link=mariadb:mariadb \
    -v image:/imagedata \
    --name ironic-conductor \
    ${USER}/ironic-conductor
