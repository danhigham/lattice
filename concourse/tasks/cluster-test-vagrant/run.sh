#!/bin/bash

set -x -e

export LATTICE_DIR=$PWD/lattice

#mkdir vagrant-up-tmp
#cd vagrant-up-tmp
#
#curl -LO https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.4_x86_64.deb
#dpkg -i vagrant_1.7.4_x86_64.deb
#
#vagrant plugin install vagrant-aws
#
##XXX# install .pem
##XXX# AWS ENVS
#
#(cp ../lattice-tar-experimental/lattice-*.tgz lattice.tgz && cp ../lattice/Vagrantfile ./ && vagrant up --provider=aws)
#
#tar zxf ltc-tar-experimental/ltc-*.tgz && ./ltc-linux-amd64 test -v -t 10m
