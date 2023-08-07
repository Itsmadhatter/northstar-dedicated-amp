#!/bin/bash

NORTHSTAR_RELEASE_URL="https://api.github.com/repos/R2Northstar/Northstar/releases/latest"
CONFIG_FILE="R2Northstar/mods/Northstar.CustomServers/mod/cfg/autoexec_ns_server.cfg"
STARTUP_CONFIG_FILE="ns_startup_args_dedi.txt"

mkdir -p /AMP/tf2northstar/serverfiles/titanfall /AMP/tf2northstar/serverfiles/northstar /AMP/tf2northstar/serverfiles/mods /AMP/tf2northstar/serverfiles/plugins /AMP/tf2northstar/serverfiles/navs

cd /AMP/tf2northstar/serverfiles/northstar

if [ -f "$CONFIG_FILE" ]; then
    cp $CONFIG_FILE $CONFIG_FILE.bak
fi

if [ ! -f "$STARTUP_CONFIG_FILE" ]; then
    cp /data/$STARTUP_CONFIG_FILE $STARTUP_CONFIG_FILE
fi

curl -s $NORTHSTAR_RELEASE_URL \
| grep "browser_download_url" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -O northstar.zip -qi -

unzip -o northstar.zip
rm northstar.zip

if [ -f "$CONFIG_FILE.bak" ]; then
    cp $CONFIG_FILE.bak $CONFIG_FILE
    rm $CONFIG_FILE.bak
fi
