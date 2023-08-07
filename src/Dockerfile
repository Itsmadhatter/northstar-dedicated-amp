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

FROM build AS build-nswrap
COPY --chown=nsbuild:nsbuild ./nswrap/ /nsbuild/src/nswrap/
RUN ulimit -n 1024; cd /nsbuild/src/nswrap && bash build.sh

FROM build AS build-entrypoint
COPY --chown=nsbuild:nsbuild ./entrypoint/ /nsbuild/src/entrypoint/
RUN ulimit -n 1024; cd /nsbuild/src/entrypoint && bash build.sh

FROM base
RUN apt-get update && apt-get install -y gnutls-bin tzdata ca-certificates sudo curl tar unzip wget

RUN --mount=from=build-wine,source=/nsbuild/src/wine,target=/nsbuild/wine \
    cd /nsbuild/wine && bash install.sh
RUN --mount=from=build-nswrap,source=/nsbuild/src/nswrap,target=/nsbuild/nswrap \
    cd /nsbuild/nswrap && bash install.sh
RUN --mount=from=build-entrypoint,source=/nsbuild/src/entrypoint,target=/nsbuild/entrypoint \
    cd /nsbuild/entrypoint && bash install.sh

RUN mkdir /data
COPY ./setup/ /data
RUN chmod +x /data/*.sh

RUN apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /nsbuild

# silence Xvfb xkbcomp warnings by working around the bug (present in libX11 1.7.2) fixed in libX11 1.8 by https://gitlab.freedesktop.org/xorg/lib/libx11/-/merge_requests/79
RUN echo 'partial xkb_symbols "evdev" {};' > /usr/share/X11/xkb/symbols/inet

EXPOSE 37015/udp
ENTRYPOINT ["/ampstart.sh"]
