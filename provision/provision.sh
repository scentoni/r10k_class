#!/bin/bash -x

sudo yum install -y https://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-7.noarch.rpm
sudo yum install -y puppet-server

sudo puppet module install puppetlabs-inifile
sudo puppet module install zack-r10k