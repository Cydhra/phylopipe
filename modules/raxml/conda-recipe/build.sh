#!/usr/bin/env bash
mkdir -p "$PREFIX/bin"
install -m 755 ./bin/raxml-ng "$PREFIX/bin/raxml-ng"