#!/bin/sh

set -ex

mkdir -p lib/build
cd lib/build
cmake ..
make

cd ../..

mkdir -p build
cd build
cmake ..
make
