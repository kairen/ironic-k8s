#!/bin/sh
#
# ironic-api boot script.
#

set -xe
ironic.conf.sh

# Start ironic api daemon
/usr/bin/ironic-api
