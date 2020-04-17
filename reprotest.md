# reprotest

[reprotest](https://tracker.debian.org/pkg/reprotest) can be used to check software reproducibility.

Use the scratch docker image as a base:
```
docker run -it --privileged scratch
```

```bash
# install reprotest and additional packages
apt reprotest install faketime sudo disorderfs

# build depends
make -C depends/ -j6 ...

# configure
./autogen.sh
./configure --prefix=/bitcoin/depends/x86_64-pc-linux-gnu

# may require running this first
make dist

# reprotest
reprotest make src/bitcoind --min-cpus=6

....

make[1]: Leaving directory '/tmp/reprotest.m2nJNM/build-experiment-1'
2020-04-17 07:33:46 W: diffoscope.main: Fuzzy-matching is currently disabled as the "tlsh" module is unavailable.
=======================
Reproduction successful
=======================
No differences in ./src/bitcoind
518192b0c2469330206655b1c34179db40f6da70ac8aae2fc2e7594bdc5ad529  ./src/bitcoind
```