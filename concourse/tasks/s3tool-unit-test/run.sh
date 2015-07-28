#!/bin/bash 

set -x -e

export LATTICE_SRC_PATH=$PWD/lattice
export GOPATH=$PWD/go
export PATH=$GOPATH/bin:$PATH

go get github.com/onsi/ginkgo/ginkgo
go get github.com/onsi/gomega

mkdir -p $GOPATH/src/github.com/cloudfoundry-incubator/lattice/cell-helpers
pushd $GOPATH/src/github.com/cloudfoundry-incubator/lattice/cell-helpers
	ln -sfv $LATTICE_SRC_PATH/cell-helpers/s3tool s3tool

	pushd s3tool
		go get -v ./...
		
		ginkgo -r -race
	popd
popd

