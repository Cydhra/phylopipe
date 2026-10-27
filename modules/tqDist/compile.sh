cmake -DCMAKE_INSTALL_PREFIX=../.. .
make -j
make test
make -j install