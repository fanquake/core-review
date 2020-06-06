### Determinism in Bitcoin Core
Being reproducibly built, Bitcoin Core semi-regularly turns up/suffers from  
determinism issues in it's own code base, as well as in it's dependencies.

This is a non-exhaustive list of some of those issues.

#### ld64 threading
ld64 is threaded, and uses a worker for each CPU to parse input files. However a  
bug in the parser caused dependencies to be calculated differently based on  
which files had already been parsed. As a result, builders with more CPUs were  
more likely to see non-determinism.

Fixed in [#9891](https://github.com/bitcoin/bitcoin/pull/9891)

Examples:
- [achow 0.14.0rc1](https://github.com/bitcoin-core/gitian.sigs/pull/471)
- [fanquake 0.14.0rc1](https://github.com/bitcoin-core/gitian.sigs/pull/470)

TODO: Determine in exactly which version of [ld64](https://opensource.apple.com/source/ld64/) this was fixed.

#### OpenSSL Embedded Timestamp
In version [1.0.1j](https://www.openssl.org/source/old/1.0.1/openssl-1.0.1j.tar.gz) OpenSSL would embed a timestamp using  

```echo "  #define DATE \"`LC_ALL=C LC_TIME=C date`\""; \```

This behaviour was in `crypto/Makefile`.  
From [1.0.1k](https://www.openssl.org/source/old/1.0.1/openssl-1.0.1k.tar.gz), the behaviour moved into `util/mkbuildinf.pl`.

Fixed after the 1.0.1k bump in [c3200bcd1e7116e079aebabed3a01dc5385bfc9e](https://github.com/bitcoin/bitcoin/commit/c3200bcd1e7116e079aebabed3a01dc5385bfc9e).


#### Win32 Protoc symbol ordering
A symbol ordering issue, `libstdc++.so.6` and `__gmon_start__` appeared to be  
swapped, in `protoc` on win32 systems caused non-determinism.  
Issue discussion in [#3725](https://github.com/bitcoin/bitcoin/issues/3725). 
Fixed in [#3742](https://github.com/bitcoin/bitcoin/pull/3742).

#### NSIS makeifle inclusion
Including the `Makefile` in the NSIS genearated documentation was causing  
determinism issues depending on wether certain programs (`gawk` & `mawk`) were  
available on the build VM.

Fixed in [#14018](https://github.com/bitcoin/bitcoin/pull/14018)

Examples:
- [fanquake 0.17.0rc1 win assert](https://github.com/bitcoin-core/gitian.sigs/blob/master/0.17.0rc1-win-unsigned/fanquake/bitcoin-win-0.17-build.assert)
- [luke-jr 0.17.0rc1 win assert](https://github.com/bitcoin-core/gitian.sigs/blob/master/0.17.0rc1-win-unsigned/luke-jr/bitcoin-win-0.17-build.assert)

#### Qt xkb handling
Qt's configure grabs the path to the xkb data root during configure. Build  
changes in Qt 5.8 broke the handling for cross-builds. This caused the string  
embedded in the binary to differ depending on wether certain files were present  
in the builders filesystem.

Fixed in [#14000](https://github.com/bitcoin/bitcoin/pull/14000)

#### Qt resource compiler embedding timestamps
After the bump to Qt 5.9, the [`rcc`](https://doc.qt.io/qt-5/rcc.html) tool was embedding timestamps  
into build output. This resulted in `qrc_bitcoin_locale.cpp`  always being  
generated in a non-deterministic way.

Upstream issue [QTBUG-62511](https://bugreports.qt.io/browse/QTBUG-62511)  
Fixed in [#13732](https://github.com/bitcoin/bitcoin/pull/13732)

### Difference in `genisoimage` binary

During the gitian builds for the 0.20.0 release luke-jr noticed that his
`bitcoin-osx-unsigned.tar.gz` was not matching anyone elses. The cause was
determined to be a small difference in the `genisoimage` binary. IRC discussion
available [here](http://www.erisian.com.au/bitcoin-core-dev/log-2020-06-03.html#l-48).

```diff
### ./genisoimage
```diff
@@ -49796,16 +49796,16 @@
 000c2830: 6400 7573 616c 6f5f 6169 7361 7461 7069  d.usalo_aisatapi
 000c2840: 0075 7361 6c6f 5f61 7265 7365 7400 7363  .usalo_areset.sc
 000c2850: 616e 5f69 6e74 6572 6e61 6c00 7367 5f61  an_internal.sg_a
 000c2860: 6d61 7064 6576 0075 7361 6c6f 5f61 6765  mapdev.usalo_age
 000c2870: 745f 6669 7273 745f 6672 6565 5f73 6869  t_first_free_shi
 000c2880: 6c6c 7962 7573 0075 7361 6c6f 5f61 6d65  llybus.usalo_ame
 000c2890: 7267 6500 7367 5f61 6d61 7064 6576 5f73  rge.sg_amapdev_s
-000c28a0: 6373 6900 6b76 2e36 3034 3100 7761 726e  csi.kv.6041.warn
-000c28b0: 5f73 7973 6673 2e36 3036 3300 7367 5f63  _sysfs.6063.sg_c
+000c28a0: 6373 6900 6b76 2e36 3034 3400 7761 726e  csi.kv.6044.warn
+000c28b0: 5f73 7973 6673 2e36 3036 3600 7367 5f63  _sysfs.6066.sg_c
 000c28c0: 6c65 6172 6e62 6c6f 636b 0073 675f 6d61  learnblock.sg_ma
 000c28d0: 7064 6576 0073 675f 7365 7475 7000 7367  pdev.sg_setup.sg
 000c28e0: 5f6d 6170 6275 7300 7367 5f69 6e69 7464  _mapbus.sg_initd
 000c28f0: 6576 0073 675f 7365 7474 696d 656f 7574  ev.sg_settimeout
 000c2900: 0073 675f 7261 6973 6564 6d61 0066 7265  .sg_raisedma.fre
 000c2910: 6164 7374 7269 6e67 0073 675f 6765 7469  adstring.sg_geti
 000c2920: 6e74 0073 675f 7277 7365 6e64 0075 7361  nt.sg_rwsend.usa
 ```

#### TODO:

mingw linker leaking bytes, [causing non-determinism](https://github.com/bitcoin/bitcoin/commit/957c0fd7c0efe2c39dde025a7d6d3d3047c86a1a#diff-92cf1b5b31c29d8281ffdc628b6da14f).  
https://github.com/bitcoin/bitcoin/pull/6900

cdrkit [determinism patch](https://github.com/bitcoin/bitcoin/blob/master/depends/patches/native_cdrkit/cdrkit-deterministic.patch)

dont add `.` to tar list - https://github.com/bitcoin/bitcoin/pull/5790