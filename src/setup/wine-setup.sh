#!/bin/bash

echo "Setup Wine"

/usr/bin/nswrap-wineprefix && \
  for x in \
      $WINEPREFIX/drive_c/"Program Files"/"Common Files"/System/*/* \
      $WINEPREFIX/drive_c/windows/* \
      $WINEPREFIX/drive_c/windows/system32/* \
      $WINEPREFIX/drive_c/windows/system32/drivers/* \
      $WINEPREFIX/drive_c/windows/system32/wbem/* \
      $WINEPREFIX/drive_c/windows/system32/spool/drivers/x64/*/* \
      $WINEPREFIX/drive_c/windows/system32/Speech/common/* \
      $WINEPREFIX/drive_c/windows/winsxs/*/* \
  ; do \
      orig="/usr/lib/wine/x86_64-windows/$(basename "$x")"; \
      if cmp -s "$orig" "$x"; then ln -sf "$orig" "$x"; fi; \
  done && \
  for x in \
      $WINEPREFIX/drive_c/windows/globalization/sorting/*.nls \
      $WINEPREFIX/drive_c/windows/system32/*.nls \
  ; do \
      orig="/usr/share/wine/nls/$(basename "$x")"; \
      if cmp -s "$orig" "$x"; then ln -sf "$orig" "$x"; fi; \
  done