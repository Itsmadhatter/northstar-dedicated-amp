#!/bin/bash

NORTHSTAR_VERSION=1.16.3
NORTHSTAR_DOWNLOAD_URL="https://github.com/R2Northstar/Northstar/releases/download/v${NORTHSTAR_VERSION}/Northstar.release.v${NORTHSTAR_VERSION}.zip"
BUILD_DIR="northstar"

# Download build deps
sudo apt-get install -y --no-install-recommends unzip

# Create build dir
mkdir -p $BUILD_DIR
cd $BUILD_DIR

# Download & unpack northstar
curl "$NORTHSTAR_DOWNLOAD_URL" --output northstar.zip
unzip northstar.zip
rm northstar.zip