#!/bin/bash

BUILD_DIR="nswrap-build"

# Download build deps
sudo apt-get install -y --no-install-recommends build-essential

# Create build dir
mkdir -p $BUILD_DIR

# Build nswrap
gcc -Wall -Wextra -Werror -Wno-trampolines -std=gnu11 -O3 -DNSWRAP_HASH="$(sha256sum $source | head -c64)" "nswrap.c" -o "$BUILD_DIR/nswrap"