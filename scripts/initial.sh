#!/bin/bash
#
# Initial environment.
#

set -xe

# Install packages
sudo yum install -y epel-release
sudo yum install -y vim git python python-pip gcc python-devel
sudo pip install -U pip
sudo pip install -U python-ironicclient
curl -fsSL "https://get.docker.com/" | sh

# Configure services
sudo setenforce 0
sudo systemctl stop firewalld && sudo systemctl disable firewalld
sudo systemctl start ntpd && sudo systemctl enable ntpd
sudo systemctl start docker && sudo systemctl enable docker
