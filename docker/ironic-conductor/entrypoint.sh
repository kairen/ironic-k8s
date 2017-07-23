#!/bin/sh
#
# ironic conductor boot script.
#

set -xe
ironic.conf.sh

# start ironic conductor daemon
/usr/bin/ironic-conductor
