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

pushd $LATTICE_SRC_PATH/build/cf-release
	git checkout $(cat $LATTICE_SRC_PATH/CF_VERSION)
	git clean -xffd
	./update
popd

$LATTICE_SRC_PATH/pipeline/01_compilation/compile_lattice_tar

pushd $LATTICE_SRC_PATH
	lattice_version=$(git describe --always --dirty)
	mv build/lattice.tgz build/lattice-${lattice_version}.tgz
popd

ls -l $LATTICE_SRC_PATH/build