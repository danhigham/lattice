#!/bin/bash 

set -x -e

export LATTICE_SRC_PATH=$PWD
export DIEGO_RELEASE_PATH=$PWD/lattice/build/diego-release
export GOPATH=$PWD/lattice/build/diego-release

rm -rf $GOPATH/src/github.com/docker/docker

go get github.com/onsi/ginkgo/ginkgo

pushd lattice/ltc
	godep restore

	./scripts/test
popd

