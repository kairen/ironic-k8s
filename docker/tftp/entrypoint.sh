#!/bin/sh
#
# tftp  boot script.
#

set -xe

/usr/sbin/in.tftpd --foreground \
                   --address 0.0.0.0:69 \
                   --secure \
                   -v -v -v -v -s \
                   --map-file /imagedata/tftpboot/map-file \
                   /imagedata/tftpboot
