#!/bin/sh
#
# copy boot-image to volume.
#

set -xe
cp -r /data/httpboot /imagedata/
cp -r /data/tftpboot /imagedata/
