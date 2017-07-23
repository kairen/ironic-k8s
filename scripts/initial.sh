#!/bin/bash
#
# Initial environment.
#

set -xe

# Install packages
sudo yum install -y epel-release vim git
sudo yum install -y python-pip python-devel \
                    libffi-devel gcc openssl-devel \
                    ansible ntp python-virtualenv \
                    python-netaddr screen

sudo pip install -U pip
curl -fsSL "https://get.docker.com/" | sh

# Configure services
sudo setenforce 0
sudo systemctl stop firewalld && sudo systemctl disable firewalld
sudo systemctl start ntpd && sudo systemctl enable ntpd
sudo systemctl start docker && sudo systemctl enable docker
