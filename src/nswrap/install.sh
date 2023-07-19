#!/bin/bash

BUILD_DIR="nswrap-build"

# Install nswrap
sudo cp "$BUILD_DIR/nswrap" /usr/bin/nswrap
sudo cp nswrap-wineprefix /usr/bin/nswrap-wineprefix
sudo chmod 755 /usr/bin/nswrap /usr/bin/nswrap-wineprefix