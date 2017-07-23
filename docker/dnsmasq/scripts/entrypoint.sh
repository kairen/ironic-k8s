#!/bin/sh
#
# dnsmasq boot script.
#

set -xe

dnsmasq.conf.sh
dnsmasq -k
