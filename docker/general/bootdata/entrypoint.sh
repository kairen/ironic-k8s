#!/bin/sh
#
# copy boot-image to volume.
#

set -xe

mkdir -p /imagedata/tmp
mkdir -p /imagedata/cache
cp -r /data/httpboot /imagedata/
cp -r /data/tftpboot /imagedata/
