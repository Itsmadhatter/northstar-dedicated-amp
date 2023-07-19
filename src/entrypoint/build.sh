#!/bin/bash

BUILD_DIR="nsdedi-build"

# Download build deps
curl -L "https://go.dev/dl/go1.20.6.linux-amd64.tar.gz" --output go.tar.gz
tar -xvzf go.tar.gz

# Create build dir
mkdir -p $BUILD_DIR

# Build entrypoint
./go/bin/go build -v -trimpath -o "$BUILD_DIR/nsdedi" .