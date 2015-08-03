#!/bin/bash

set -x -e

export LATTICE_DIR=$PWD/lattice
export LATTICE_VERSION=$(git -C $LATTICE_DIR describe)

git -C "$LATTICE_DIR" push origin "$LATTICE_VERSION"