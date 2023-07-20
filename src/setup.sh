#!/bin/bash
# AMP setup script

NORTHSTAR_VERSION=1.16.3
NORTHSTAR_DOWNLOAD_URL="https://github.com/R2Northstar/Northstar/releases/download/v${NORTHSTAR_VERSION}/Northstar.release.v${NORTHSTAR_VERSION}.zip"

mkdir -p /AMP/serverfiles/titanfall /AMP/serverfiles/northstar /AMP/serverfiles/mods /AMP/serverfiles/plugins /AMP/serverfiles/navs

cd /AMP/serverfiles/northstar

curl -L "$NORTHSTAR_DOWNLOAD_URL" --output northstar.zip
unzip -o northstar.zip
rm northstar.zip

export WINEPREFIX="/home/amp/.wine"
/usr/bin/nswrap-wineprefix && \
  for x in \
      /home/amp/.wine/drive_c/"Program Files"/"Common Files"/System/*/* \
      /home/amp/.wine/drive_c/windows/* \
      /home/amp/.wine/drive_c/windows/system32/* \
      /home/amp/.wine/drive_c/windows/system32/drivers/* \
      /home/amp/.wine/drive_c/windows/system32/wbem/* \
      /home/amp/.wine/drive_c/windows/system32/spool/drivers/x64/*/* \
      /home/amp/.wine/drive_c/windows/system32/Speech/common/* \
      /home/amp/.wine/drive_c/windows/winsxs/*/* \
  ; do \
      orig="/usr/lib/wine/x86_64-windows/$(basename "$x")"; \
      if cmp -s "$orig" "$x"; then ln -sf "$orig" "$x"; fi; \
  done && \
  for x in \
      /home/amp/.wine/drive_c/windows/globalization/sorting/*.nls \
      /home/amp/.wine/drive_c/windows/system32/*.nls \
  ; do \
      orig="/usr/share/wine/nls/$(basename "$x")"; \
      if cmp -s "$orig" "$x"; then ln -sf "$orig" "$x"; fi; \
  done