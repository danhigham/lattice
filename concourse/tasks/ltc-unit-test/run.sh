#!/bin/bash 

set -x -e

export LATTICE_SRC_PATH=$PWD/lattice
export DIEGO_RELEASE_PATH=$PWD/lattice/build/diego-release
export GOPATH=$DIEGO_RELEASE_PATH
export PATH=$GOPATH/bin:$PATH

pushd $DIEGO_RELEASE_PATH
	git checkout $(cat $LATTICE_SRC_PATH/DIEGO_VERSION)
	git clean -xffd
	./scripts/update
popd

rm -rf $GOPATH/src/github.com/docker/docker

go get github.com/onsi/ginkgo/ginkgo

pushd $GOPATH/src/github.com/cloudfoundry-incubator
	## make me relative
	ln -sfv $LATTICE_SRC_PATH lattice
popd

pushd $GOPATH/src/github.com/cloudfoundry-incubator/lattice/ltc
	godep restore

	./scripts/test
popd

