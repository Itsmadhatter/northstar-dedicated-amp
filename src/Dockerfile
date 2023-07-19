# syntax=docker/dockerfile:1.2

FROM cubecoders/ampbase AS base

FROM base AS build
RUN apt-get update && apt-get install -y sudo curl tar
RUN adduser --gecos '' --disabled-password --home /nsbuild nsbuild && \
    echo 'nsbuild ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/nsbuild

USER nsbuild
RUN mkdir -p /nsbuild/src

FROM build AS build-wine
COPY --chown=nsbuild:nsbuild ./wine/ /nsbuild/src/wine/
RUN ulimit -n 1024; cd /nsbuild/src/wine && bash build.sh

FROM build AS build-northstar
COPY --chown=nsbuild:nsbuild ./northstar/ /nsbuild/src/northstar/
RUN ulimit -n 1024; cd /nsbuild/src/northstar && bash build.sh

FROM build AS build-nswrap
COPY --chown=nsbuild:nsbuild ./nswrap/ /nsbuild/src/nswrap/
RUN ulimit -n 1024; cd /nsbuild/src/nswrap && bash build.sh

FROM build AS build-entrypoint
COPY --chown=nsbuild:nsbuild ./entrypoint/ /nsbuild/src/entrypoint/
RUN ulimit -n 1024; cd /nsbuild/src/entrypoint && bash build.sh

FROM base
RUN apt-get update && apt-get install -y gnutls-bin tzdata ca-certificates sudo
RUN --mount=from=build-wine,source=/nsbuild/src/wine,target=/nsbuild/wine \
    cd /nsbuild/wine && bash install.sh
RUN --mount=from=build-northstar,source=/nsbuild/src/northstar,target=/nsbuild/northstar \
    cd /nsbuild/northstar && bash install.sh
RUN --mount=from=build-nswrap,source=/nsbuild/src/nswrap,target=/nsbuild/nswrap \
    cd /nsbuild/nswrap && bash install.sh
RUN --mount=from=build-entrypoint,source=/nsbuild/src/entrypoint,target=/nsbuild/entrypoint \
    cd /nsbuild/entrypoint && bash install.sh

# silence Xvfb xkbcomp warnings by working around the bug (present in libX11 1.7.2) fixed in libX11 1.8 by https://gitlab.freedesktop.org/xorg/lib/libx11/-/merge_requests/79
RUN echo 'partial xkb_symbols "evdev" {};' > /usr/share/X11/xkb/symbols/inet

#RUN adduser --gecos '' --disabled-password northstar && \
    #echo 'northstar ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/northstar && \
USER root
RUN mkdir -p /AMP/serverfiles/titanfall /AMP/serverfiles/mods /AMP/serverfiles/navs /AMP/serverfiles/plugins /AMP/serverfiles/northstar

ENV WINEPREFIX="/home/amp/.wine"
RUN mkdir -p ${WINEPREFIX}
RUN /usr/bin/nswrap-wineprefix && \
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
EXPOSE 8081/tcp
EXPOSE 37015/udp
ENTRYPOINT ["/ampstart.sh"]
