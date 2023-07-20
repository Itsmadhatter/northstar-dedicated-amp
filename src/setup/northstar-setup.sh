#!/bin/bash

NORTHSTAR_VERSION=1.16.3
NORTHSTAR_DOWNLOAD_URL="https://github.com/R2Northstar/Northstar/releases/download/v${NORTHSTAR_VERSION}/Northstar.release.v${NORTHSTAR_VERSION}.zip"
CONFIG_FILE="R2Northstar/mods/Northstar.CustomServers/mod/cfg/autoexec_ns_server.cfg"
STARTUP_CONFIG_FILE="ns_startup_args_dedi.txt"

echo "Installing Northstar"

mkdir -p /AMP/serverfiles/titanfall /AMP/serverfiles/northstar /AMP/serverfiles/mods /AMP/serverfiles/plugins /AMP/serverfiles/navs

cd /AMP/serverfiles/northstar

if [ -f "$CONFIG_FILE" ]; then
    cp $CONFIG_FILE $CONFIG_FILE.bak
fi

if [ ! -f "$STARTUP_CONFIG_FILE" ]; then
    cp /data/$STARTUP_CONFIG_FILE $STARTUP_CONFIG_FILE
fi

curl -L "$NORTHSTAR_DOWNLOAD_URL" --output northstar.zip
unzip -o northstar.zip
rm northstar.zip

if [ -f "$CONFIG_FILE.bak" ]; then
    cp $CONFIG_FILE.bak $CONFIG_FILE
    rm $CONFIG_FILE.bak
fi