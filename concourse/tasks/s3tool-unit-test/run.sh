#!/bin/bash

set -x -e

export LATTICE_SRC_PATH=$PWD/lattice

mkdir -p $PWD/go/src/github.com/cloudfoundry-incubator $PWD/go/bin
ln -sf $LATTICE_SRC_PATH $PWD/go/src/github.com/cloudfoundry-incubator/lattice

export GOPATH=$PWD/go
export PATH=$GOPATH/bin:$PATH

go get github.com/onsi/ginkgo/ginkgo

pushd $LATTICE_SRC_PATH/cell-helpers/s3tool
  go get -v ./...
  ginkgo -r --randomizeAllSpecs --randomizeSuites --failOnPending --trace --race .
popd
