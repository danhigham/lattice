#!/bin/bash

set -x -e

export LATTICE_SRC_PATH=$PWD/lattice

mkdir -p $PWD/go/src/github.com/cloudfoundry-incubator
ln -sf $LATTICE_SRC_PATH $PWD/go/src/github.com/cloudfoundry-incubator/lattice

export LATTICE_VERSION=$(git -C $LATTICE_SRC_PATH describe)
export DIEGO_VERSION=$(cat $LATTICE_SRC_PATH/DIEGO_VERSION)

export GOPATH=$LATTICE_SRC_PATH/ltc/Godeps/_workspace:$PWD/go

GOARCH=amd64 GOOS=linux go build \
    -ldflags \
        "-X github.com/cloudfoundry-incubator/lattice/ltc/setup_cli.latticeVersion $LATTICE_VERSION
         -X github.com/cloudfoundry-incubator/lattice/ltc/setup_cli.diegoVersion $DIEGO_VERSION" \
    -o ltc-linux-amd64 \
    github.com/cloudfoundry-incubator/lattice/ltc

GOARCH=amd64 GOOS=darwin go build \
    -ldflags \
        "-X github.com/cloudfoundry-incubator/lattice/ltc/setup_cli.latticeVersion $LATTICE_VERSION
         -X github.com/cloudfoundry-incubator/lattice/ltc/setup_cli.diegoVersion $DIEGO_VERSION" \
    -o ltc-darwin-amd64 \
    github.com/cloudfoundry-incubator/lattice/ltc

tar czf $LATTICE_SRC_PATH/build/ltc-${LATTICE_VERSION}.tgz ltc-linux-amd64 ltc-darwin-amd64
