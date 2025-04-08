#!/usr/bin/env bash

if [ ! -d "src" ]; then
  echo "Please run this script from the root directory of the consel repository."
  exit 1
fi

pushd src
make
make install
make clean
popd

ls ./bin/consel >> /dev/null
if [ $? -ne 0 ]; then
  echo "Compilation failed. Please check the output for errors."
  exit 1
fi

exit 0