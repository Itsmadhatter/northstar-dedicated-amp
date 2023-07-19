#!/bin/bash

BUILD_DIR="nsdedi-build"

# Install entrypoint
sudo cp "$BUILD_DIR/nsdedi" /usr/libexec/nsdedi
sudo chmod 755 /usr/libexec/nsdedi