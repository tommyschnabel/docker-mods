# syntax=docker/dockerfile:1

## Alpine Buildstage ##
FROM ghcr.io/linuxserver/baseimage-alpine:3.22 AS buildstage_alpine

# copy local files
COPY root/ /root-layer/

RUN echo "**** install packages ****"                                          && \
    apk add sqlite icu-dev build-base git --no-cache                           && \
    echo "**** clone sqlite and checkout version matching our system ****"     && \
    git clone https://github.com/sqlite/sqlite.git -b "version-$(sqlite3 --version | cut -d ' ' -f 1)" && \
    cd sqlite                                                                  && \
    echo "**** recompile sqlite with icu extension ****"                       && \
    CFLAGS="-O2 -DSQLITE_ENABLE_ICU $(pkg-config --cflags icu-uc icu-io)"         \
    LDFLAGS="$(pkg-config --libs icu-uc icu-io)" ./configure --enable-shared   && \
    make                                                                       && \
    echo "**** install into /root-layer/defaults/sqlite_icu/alpine ****"       && \
    mkdir -p /root-layer/sqlite_icu/alpine                                     && \
    make install DESTDIR=/root-layer/defaults/sqlite_icu/alpine

## Ubuntu Buildstage ##
FROM ghcr.io/linuxserver/baseimage-ubuntu:noble AS buildstage_ubuntu

# copy local files
COPY --from=buildstage_alpine root-layer/ /root-layer/

RUN echo "**** install packages ****"                                          && \
    apt update                                                                 && \
    apt install -y sqlite3 libicu-dev build-essential git tclsh pkg-config     && \
    echo "**** clone sqlite and checkout version matching our system ****"     && \
    git clone https://github.com/sqlite/sqlite.git -b "version-$(sqlite3 --version | cut -d ' ' -f 1)" && \
    cd sqlite                                                                  && \
    git checkout "version-$(sqlite3 --version | cut -d ' ' -f 1)"              && \
    echo "**** recompile sqlite with icu extension ****"                       && \
    CFLAGS="-O2 -DSQLITE_ENABLE_ICU $(pkg-config --cflags icu-uc icu-io)"         \
    LDFLAGS="$(pkg-config --libs icu-uc icu-io)" ./configure --enable-shared   && \
    make                                                                       && \
    echo "**** install into /root-layer/defaults/sqlite_icu/ubuntu ****"       && \
    mkdir -p /root-layer/sqlite_icu/ubuntu                                     && \
    make install DESTDIR=/root-layer/defaults/sqlite_icu/ubuntu

## Single layer deployed image ##
FROM scratch

LABEL maintainer="tommyschnabel"

# Add files from buildstage
COPY --from=buildstage_ubuntu /root-layer/ /
