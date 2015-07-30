#!/bin/bash

set -x -e

export LATTICE_DIR=$PWD/lattice
export LATTICE_VERSION=$(git -C $LATTICE_DIR describe)

cat $LATTICE_DIR/terraform/aws/example | sed  's/source = "github\.com.*$/source = "github\.com\/cloudfoundry-incubator\/lattice\/\/terraform\/\/aws\?ref='"$LATTICE_VERSION"'"/' > lattice.aws.tf
cat $LATTICE_DIR/terraform/digitalocean/example | sed -i 's/source = "github\.com.*$/source = "github\.com\/cloudfoundry-incubator\/lattice\/\/terraform\/\/digitalocean\?ref='"$LATTICE_VERSION"'"/' > lattice.digitalocean.tf
cat $LATTICE_DIR/terraform/google/example | sed -i 's/source = "github\.com.*$/source = "github\.com\/cloudfoundry-incubator\/lattice\/\/terraform\/\/google\?ref='"$LATTICE_VERSION"'"/' > lattice.google.tf
cat $LATTICE_DIR/terraform/openstack/example | sed -i 's/source = "github\.com.*$/source = "github\.com\/cloudfoundry-incubator\/lattice\/\/terraform\/\/openstack\?ref='"$LATTICE_VERSION"'"/' > lattice.openstack.tf
