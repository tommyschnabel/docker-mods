# SQLite + ICU Extension, adding unicode support to SQLite

This mod replaces the existing SQLite installation (usually compiled without the ICU Extension enabled reduce library size) with a version compiled with the ICU extension, adding Unicode unicode support.

Alpine Linux and Ubuntu images are currently supported, and SQLite has been compiled with the version that already exists on those images at build-time, with the hope to avoid any incompatibility issues that might come with blindly picking the latest version.

# Usage
In any linuxserver.io container, add the following environment variable:
```
DOCKER_MODS=linuxserver/mods:universal-sqlite-icu-extension
```

If you're already using another mod, you can install it alongside by separating the mods with `|`:
```
DOCKER_MODS=linuxserver/mods:universal-sqlite-icu-extension|linuxserver/mods:my-other-mod
```


# Files that are installed with this mod
SQLite3 is compiled from source for each of the base images defined in the Dockerfile, ensuring the ICU Extension is included.
As such, the files that are incuded with a normal sqlite3 installation are included in the mod and will be copied into its typical install locations as executed by a `make install` in the sqlite repo.

Here is a sample of the files that are produced and packaged into the s6-overlay `/defaults` directory:
```
defaults/sqlite_icu/alpine/usr/local/bin/sqlite3
defaults/sqlite_icu/alpine/usr/local/include/sqlite3.h
defaults/sqlite_icu/alpine/usr/local/include/sqlite3ext.h
defaults/sqlite_icu/alpine/usr/local/lib/libsqlite3.a
defaults/sqlite_icu/alpine/usr/local/lib/libsqlite3.so
defaults/sqlite_icu/alpine/usr/local/lib/libsqlite3.so.0
defaults/sqlite_icu/alpine/usr/local/lib/libsqlite3.so.3.49.2
defaults/sqlite_icu/alpine/usr/local/lib/pkgconfig/sqlite3.pc
defaults/sqlite_icu/alpine/usr/local/share/man/man1/sqlite3.1
defaults/sqlite_icu/ubuntu/usr/local/bin/sqlite3
defaults/sqlite_icu/ubuntu/usr/local/include/sqlite3.h
defaults/sqlite_icu/ubuntu/usr/local/include/sqlite3ext.h
defaults/sqlite_icu/ubuntu/usr/local/lib/libsqlite3.a
defaults/sqlite_icu/ubuntu/usr/local/lib/libsqlite3.la
defaults/sqlite_icu/ubuntu/usr/local/lib/libsqlite3.so
defaults/sqlite_icu/ubuntu/usr/local/lib/libsqlite3.so.0
defaults/sqlite_icu/ubuntu/usr/local/lib/libsqlite3.so.0.8.6
defaults/sqlite_icu/ubuntu/usr/local/lib/pkgconfig/sqlite3.pc
```
