# rtld-audit - Dynamic Linker Auditing

The GNU dynamic linker provides an [auditing api](https://linux.die.net/man/7/rtld-audit). We can use it to observe dynamic linking events for `bitcoind` and `bitcoin-qt`. Note that what's being done here can be more easily achieved using various `ld` environment variables at runtime. i.e `LD_DEBUG=all`.

Start a [debian-depends](../docker/debian.dockerfile) Docker container.

```bash
# copy the audit source into the container
docker cp audit.cpp container_id:.
```

Inside the container:

```bash
# build the audit shared library
g++ -std=c++11 -Wall -Werror -shared audit.cpp -o audit.so

# build bitcoind
pushd bitcoin
make -C depends -j5 NO_WALLET=1 NO_QT=1 NO_UPNP=1 NO_ZMQ=1
./autogen.sh
./configure --prefix=/bitcoin/depends/x86_64-pc-linux-gnu
make src/bitcoind -j5
```

Using the auditing library at runtime:

```bash
LD_AUDIT="/audit.so" src/bitcoind

Auditing interface version: 1
loading shared object: , flag = LM_ID_BASE
loading shared object: /lib64/ld-linux-x86-64.so.2, flag = LM_ID_BASE
Link map activity:
 Cookie = 0x7f2523a76608, flag = LA_ACT_ADD
loading shared object: /lib/x86_64-linux-gnu/libpthread.so.0, flag = LM_ID_BASE
loading shared object: /usr/lib/x86_64-linux-gnu/libstdc++.so.6, flag = LM_ID_BASE
loading shared object: /lib/x86_64-linux-gnu/libm.so.6, flag = LM_ID_BASE
loading shared object: /lib/x86_64-linux-gnu/libgcc_s.so.1, flag = LM_ID_BASE
loading shared object: /lib/x86_64-linux-gnu/libc.so.6, flag = LM_ID_BASE
Link map activity:
 Cookie = 0x7f2523a76608, flag = LA_ACT_CONSISTENT
Dynamic linker finished. Passing back to application
2019-12-04T14:57:29Z Feeding 23672 bytes of environment data into RNG
2019-12-04T14:57:29Z Bitcoin Core version v0.19.99.0-41919631d (release build)

# .... running

2019-12-04T14:57:33Z FlushStateToDisk: write coins cache to disk (0 coins, 0kB) completed (0.00s)
2019-12-04T14:57:34Z Shutdown: done
About to unload object. Cookie = 0x7f2523a76608
About to unload object. Cookie = 0x7f2523a444e8
About to unload object. Cookie = 0x7f2523a44a08
About to unload object. Cookie = 0x7f2523a44f18
About to unload object. Cookie = 0x7f2523a45428
About to unload object. Cookie = 0x7f2523a45938
About to unload object. Cookie = 0x7f2523a75e68
```

When running `bitcoin-qt`, as expected, there is substantially more dynamic linker activity.
Note the activity happening after "Dynamic linker finished.". This is Qt dlopening `dbus`.

```bash
LD_AUDIT="/home/bitcoin/audit.so" src/qt/bitcoin-qt
Auditing interface version: 1
loading shared object: , flag = LM_ID_BASE

loading shared object: /lib64/ld-linux-x86-64.so.2, flag = LM_ID_BASE

Link map activity:
 Cookie = 0x7f6f12d7f608, flag = LA_ACT_ADD	

loading shared object: /lib/x86_64-linux-gnu/libpthread.so.0, flag = LM_ID_BASE
loading shared object: /lib/x86_64-linux-gnu/libfontconfig.so.1, flag = LM_ID_BASE
loading shared object: /lib/x86_64-linux-gnu/libfreetype.so.6, flag = LM_ID_BASE
loading shared object: /lib/x86_64-linux-gnu/libxcb.so.1, flag = LM_ID_BASE
loading shared object: /lib/x86_64-linux-gnu/libdl.so.2, flag = LM_ID_BASE
loading shared object: /lib/x86_64-linux-gnu/libm.so.6, flag = LM_ID_BASE
loading shared object: /lib/x86_64-linux-gnu/libstdc++.so.6, flag = LM_ID_BASE
loading shared object: /lib/x86_64-linux-gnu/libgcc_s.so.1, flag = LM_ID_BASE
loading shared object: /lib/x86_64-linux-gnu/libc.so.6, flag = LM_ID_BASE
loading shared object: /lib/x86_64-linux-gnu/libexpat.so.1, flag = LM_ID_BASE
loading shared object: /lib/x86_64-linux-gnu/libuuid.so.1, flag = LM_ID_BASE
loading shared object: /lib/x86_64-linux-gnu/libpng16.so.16, flag = LM_ID_BASE
loading shared object: /lib/x86_64-linux-gnu/libz.so.1, flag = LM_ID_BASE
loading shared object: /lib/x86_64-linux-gnu/libXau.so.6, flag = LM_ID_BASE
loading shared object: /lib/x86_64-linux-gnu/libXdmcp.so.6, flag = LM_ID_BASE
loading shared object: /lib/x86_64-linux-gnu/libbsd.so.0, flag = LM_ID_BASE

Link map activity:
 Cookie = 0x7f6f12d7f608, flag = LA_ACT_CONSISTENT

Dynamic linker finished. Passing back to application
Link map activity:
 Cookie = 0x7f6f12d7f608, flag = LA_ACT_ADD

loading shared object: /lib/x86_64-linux-gnu/libdbus-1.so.3, flag = LM_ID_BASE
loading shared object: /lib/x86_64-linux-gnu/libsystemd.so.0, flag = LM_ID_BASE
loading shared object: /lib/x86_64-linux-gnu/librt.so.1, flag = LM_ID_BASE
loading shared object: /lib/x86_64-linux-gnu/liblzma.so.5, flag = LM_ID_BASE
loading shared object: /lib/x86_64-linux-gnu/liblz4.so.1, flag = LM_ID_BASE
loading shared object: /lib/x86_64-linux-gnu/libgcrypt.so.20, flag = LM_ID_BASE
loading shared object: /lib/x86_64-linux-gnu/libgpg-error.so.0, flag = LM_ID_BASE

Link map activity:
 Cookie = 0x7f6f12d7f608, flag = LA_ACT_CONSISTENT

About to unload object. Cookie = 0x559366447348
About to unload object. Cookie = 0x559366447808
About to unload object. Cookie = 0x559366448188
About to unload object. Cookie = 0x559366448648
About to unload object. Cookie = 0x559366448b08
About to unload object. Cookie = 0x55936646a808
Link map activity:
 Cookie = 0x7f6f12d7f608, flag = LA_ACT_DELETE

Link map activity:
 Cookie = 0x7f6f12d7f608, flag = LA_ACT_CONSISTENT

About to unload object. Cookie = 0x7f6f12d7f608
About to unload object. Cookie = 0x7f6f12b45498
About to unload object. Cookie = 0x7f6f12b459b8
About to unload object. Cookie = 0x7f6f12b45ed8
About to unload object. Cookie = 0x7f6f128f5478
About to unload object. Cookie = 0x7f6f128f5e98
About to unload object. Cookie = 0x7f6f128f63b8
About to unload object. Cookie = 0x7f6f128f6e18
About to unload object. Cookie = 0x7f6f12377478
About to unload object. Cookie = 0x7f6f12377a08
About to unload object. Cookie = 0x7f6f128f5988
About to unload object. Cookie = 0x7f6f12377f18
About to unload object. Cookie = 0x7f6f12378478
About to unload object. Cookie = 0x7f6f12378998
About to unload object. Cookie = 0x7f6f1230a478
About to unload object. Cookie = 0x559366447cc8
About to unload object. Cookie = 0x7f6f12b44f78
About to unload object. Cookie = 0x7f6f128f68c8
About to unload object. Cookie = 0x7f6f12d7ee60
```
