# Binary Comparison

These notes use the [debian-depends Dockerfile](/docker/debian.dockerfile).

## Build

```bash
docker container start debian-depends
docker exec -it debian-depends --workdir /bitcoin /bin/bash

# build master
make -j5 -C depends/
git rev-parse HEAD
> 25f0edd59fee454495da39c6c63f19b97cd75e96
../bitcoin-maintainer-tools/build-for-compare.py 25f0edd59fee454495da39c6c63f19b97cd75e96 \
        --prefix=/bitcoin/depends/x86_64-pc-linux-gnu \
        --executables=src/bitcoind,src/qt/bitcoin-qt \
        --parallelism=5
......
>>> [do_build] Copying object files...
>>> [do_build] Performing basic analysis pass...

# Checkout the PR you'd like to compare. In this case #16370
git fetch origin pull/16370/head:16370 && git checkout 16370
make -j5 -C depends/
git rev-parse HEAD
12061016eca4cf4c77fa042ea95682e5dc2b302b
# build for comparison into /tmp/16370
../bitcoin-maintainer-tools/build-for-compare.py 12061016eca4cf4c77fa042ea95682e5dc2b302b \
        --prefix=/bitcoin/depends/x86_64-pc-linux-gnu \
        --executables=src/bitcoind,src/qt/bitcoin-qt \
        --parallelism=5 \
        --tgtdir=/tmp/16370
.....
>>> [do_build] Copying object files...
>>> [do_build] Performing basic analysis pass...
```

## Result

The contents of a build-for-compare directory is:

```bash
`25f0edd59fee454495da39c6c63f19b97cd75e96` contains `.dis` files
`25f0edd59fee454495da39c6c63f19b97cd75e96.o/src` contains `.o` files

# ELF 64-bit LSB pie executable, x86-64, version 1 (GNU/Linux), 
# dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 3.2.0, 
# BuildID[sha1]=724e4aaaa656445719d92dc9c4fb82fe7a2fe8c5, not stripped
`bitcoin-qt.25f0edd59fee454495da39c6c63f19b97cd75e96` bitcoin-qt executable
`bitcoin-qt.25f0edd59fee454495da39c6c63f19b97cd75e96.stripped` bitcoin-qt executable, stripped

# ELF 64-bit LSB pie executable, x86-64, version 1 (GNU/Linux), 
# dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 3.2.0, 
# BuildID[sha1]=6ad35cd12f6a7024b169797a1abb190cc2aa276f, not stripped
`bitcoind.25f0edd59fee454495da39c6c63f19b97cd75e96` bitcoind executable
`bitcoind.25f0edd59fee454495da39c6c63f19b97cd75e96.stripped` bitcoind executable, stripped
```

## Compare

```bash
# Compare executable shasums
shasum /tmp/compare/*.stripped /tmp/16370/*.stripped
0e8a7a100bb6ef00e9ead3cb64474ec28590d7c6  /tmp/compare/bitcoin-qt.25f0edd59fee454495da39c6c63f19b97cd75e96.stripped
8552038318e5b09d3484de1087b413a2aa548f24  /tmp/compare/bitcoind.25f0edd59fee454495da39c6c63f19b97cd75e96.stripped
5c648d92e6d696ca090c28f3db98cd59cdcc6a44  /tmp/16370/bitcoin-qt.12061016eca4cf4c77fa042ea95682e5dc2b302b.stripped
b72c2949587965cc18c32fcdf5e5ae187f4ef819  /tmp/16370/bitcoind.12061016eca4cf4c77fa042ea95682e5dc2b302b.stripped

# diffoscope bitcoind binaries
diffoscope compare/bitcoind.25f0edd59fee454495da39c6c63f19b97cd75e96 16370/bitcoind.12061016eca4cf4c77fa042ea95682e5dc2b302b
```
