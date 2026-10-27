#!/usr/bin/env bash
mkdir -p "$PREFIX/bin"
install -m 755 ./bin/all_pairs_quartet_dist ./bin/all_pairs_triplet_dist ./bin/pairs_quartet_dist ./bin/pairs_triplet_dist ./bin/quartet_dist ./bin/triplet_dist "$PREFIX/bin/"