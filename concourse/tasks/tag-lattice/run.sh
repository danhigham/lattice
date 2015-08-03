#!/bin/bash

set -x -e

export LATTICE_DIR=$PWD/lattice
export LATTICE_VERSION=$(cat $LATTICE_DIR/Version)

git -C "$LATTICE_DIR" push origin "$LATTICE_VERSION"