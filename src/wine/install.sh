#!/bin/bash

WINE_VERSION=7.0
BUILD_DIR="wine-${WINE_VERSION}"

sudo apt-get install -y --no-install-recommends xvfb

cd $BUILD_DIR
sudo dpkg -i *.deb

sudo cp tools/wineapploader /usr/bin/wineapploader
sudo chmod 755 /usr/bin/wineapploader

for file in msiexec notepad regedit regsvr32 wineboot \
		winecfg wineconsole winefile winemine winepath
	do
		if sudo rm /usr/bin/$file; then
			sudo ln -sf /usr/bin/wineapploader /usr/bin/$file
		fi
done