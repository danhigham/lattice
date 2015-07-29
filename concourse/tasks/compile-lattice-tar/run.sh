#!/bin/bash 

set -x -e

export LATTICE_SRC_PATH=$PWD/lattice
export DIEGO_RELEASE_PATH=$PWD/lattice/build/diego-release
export GOPATH=$DIEGO_RELEASE_PATH
export PATH=$GOPATH/bin:$PATH

## should not need this
# rm -rf $GOPATH/src/github.com/docker/docker

## should not need this
# pushd $GOPATH/src/github.com/cloudfoundry-incubator
# 	## make me relative
# 	ln -sfv $LATTICE_SRC_PATH lattice
# popd

$LATTICE_SRC_PATH/pipeline/01_compilation/compile_lattice_tar


