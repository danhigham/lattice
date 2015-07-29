#!/bin/bash 

set -x -e

export LATTICE_SRC_PATH=$PWD/lattice
export DIEGO_RELEASE_PATH=$PWD/lattice/build/diego-release
export GOPATH=$DIEGO_RELEASE_PATH
export PATH=$GOPATH/bin:$PATH

pushd $DIEGO_RELEASE_PATH
	git checkout $(cat $LATTICE_SRC_PATH/DIEGO_VERSION)
	./scripts/update
popd

$LATTICE_SRC_PATH/pipeline/01_compilation/compile_ltc


pushd $LATTICE_SRC_PATH
	lattice_version=$(git describe --always --dirty)
	mv build/ltc.tar.gz build/ltc-${lattice_version}.tgz
popd

ls -l $LATTICE_SRC_PATH/build