# syntax=docker/dockerfile:1

## Buildstage ##
FROM ghcr.io/linuxserver/baseimage-alpine:3.22 AS buildstage

# copy local files
COPY root/ /root-layer/

RUN echo "**** install packages ****"                                          && \
    apk add sqlite icu-dev build-base git --no-cache                           && \
    echo "**** clone sqlite and checkout version matching our system ****"     && \
    git clone https://github.com/sqlite/sqlite.git -b "version-$(sqlite3 --version | cut -d ' ' -f 1)" && \
    cd sqlite                                                                  && \
    echo "**** recompile sqlite with icu extension ****"                       && \
    CFLAGS="-O2 -DSQLITE_ENABLE_ICU `pkg-config --cflags icu-uc icu-io`"          \
    LDFLAGS="`pkg-config --libs icu-uc icu-io`" ./configure --enable-shared    && \
    make                                                                       && \
    echo "**** copy sqlite to root-layer ****"                                 && \
    cp ./libsqlite3* /root-layer/

## Single layer deployed image ##
FROM scratch

LABEL maintainer="tommyschnabel"

# Add files from buildstage
COPY --from=buildstage /root-layer/ /
