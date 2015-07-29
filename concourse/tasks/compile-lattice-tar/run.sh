#!/bin/bash

set -x -e

export LATTICE_SRC_PATH=$PWD/lattice
export DIEGO_RELEASE_PATH=$PWD/lattice/build/diego-release
export GOPATH=$DIEGO_RELEASE_PATH
export PATH=$GOPATH/bin:$PATH

export LATTICE_VERSION=$(git -C $LATTICE_SRC_PATH describe)
export DIEGO_VERSION=$(cat $LATTICE_SRC_PATH/DIEGO_VERSION)
export CF_VERSION=$(cat $LATTICE_SRC_PATH/CF_VERSION)

pushd $DIEGO_RELEASE_PATH
	git checkout $DIEGO_VERSION
	git clean -xffd
	./scripts/update
popd

pushd $LATTICE_SRC_PATH/build/cf-release
	git checkout $CF_VERSION
	git clean -xffd
	./update
popd

$LATTICE_SRC_PATH/cluster/scripts/compile \
    $LATTICE_SRC_PATH/build/lattice-build \
    $LATTICE_SRC_PATH/build/diego-release \
    $LATTICE_SRC_PATH/build/cf-release \
    $LATTICE_SRC_PATH

echo $LATTICE_VERSION > $LATTICE_SRC_PATH/build/lattice-build/common/LATTICE_VERSION
echo $DIEGO_VERSION > $LATTICE_SRC_PATH/build/lattice-build/common/DIEGO_VERSION
echo $CF_VERSION > $LATTICE_SRC_PATH/build/lattice-build/common/CF_VERSION

tar -C $LATTICE_SRC_PATH/build czf lattice.tgz lattice-build

mv $LATTICE_SRC_PATH/build/lattice.tgz $LATTICE_SRC_PATH/build/lattice-${lattice_version}.tgz

