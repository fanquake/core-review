# diffoscope

[`diffoscope`](https://diffoscope.org) is a tool for generating diffs of just about anything (files, archives or directories).

## Creating diffs for GitHub

```bash
diffoscope first_file second_file --markdown diff.md # --exclude-directory-metadata
gsed -i '/## /a ```diff' diff.md
gsed -i '/## /i ```' diff.md
gsed -i 's/    //g' diff.md
```

This may need some manual cleanup depending on the actual diff produced.

## Diffing the depends directory

Diffing `depends` directories after changing the build process, i.e [#15844](https://github.com/bitcoin/bitcoin/pull/15844).

Depends is built once, and moved to `x86_64-apple-darwin18.5.0-master`. Then the PR is merged, and depends is rebuilt.

```shell
diffoscope x86_64-apple-darwin18.5.0-master/lib x86_64-apple-darwin18.5.0/lib --markdown - | sed -e 's/^[ ^t]*//' -e '1,/@@/d' -e '/## stat {}/,$d' > diff.txt
```

```diff
cat diff.txt

libboost_unit_test_framework-mt.a
libcrypto.a
libdb-4.8.a
libdb.a
libdb_cxx-4.8.a
libdb_cxx.a
libevent.a
-libevent.la
libevent_core.a
-libevent_core.la
libevent_extra.a
-libevent_extra.la
libevent_pthreads.a
-libevent_pthreads.la
libminiupnpc.a
libprotobuf-lite.a
-libprotobuf-lite.la
libprotobuf.a
-libprotobuf.la
-libprotoc.la
libqrencode.a
-libqrencode.la
libqtharfbuzz.a
libqtlibpng.a
libqtpcre2.a
librapidcheck.a
libssl.a
libz.a
libzmq.a
-libzmq.la
pkgconfig
pkgconfig/Qt5AccessibilitySupport.pc
pkgconfig/Qt5CglSupport.pc
pkgconfig/Qt5ClipboardSupport.pc
pkgconfig/Qt5Core.pc
pkgconfig/Qt5DBus.pc
pkgconfig/Qt5DeviceDiscoverySupport.pc
```
