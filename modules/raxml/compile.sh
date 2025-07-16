#!/usr/bin/env bash

if [ ! -d "src" ]; then
  echo "Please run this script from the root directory of the raxml-ng repository."
  exit 1
fi

mkdir build && pushd build
cmake -DSTATIC_BUILD=ON -DCORAX_BUILD_PORTABLE_ARCH=haswell ..
make
popd

./bin/raxml-ng-2 --version > /dev/null
if [ $? -ne 0 ]; then
  echo "Compilation failed. Please check the output for errors."
  exit 1
fi

exit 0