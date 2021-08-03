# reprotest

[reprotest](https://tracker.debian.org/pkg/reprotest) can be used to check software reproducibility.

Use the base docker image:
```
docker run -it --privileged base
```

```bash
# install reprotest and additional packages
apt install reprotest faketime sudo disorderfs

# build depends
make -C depends/ -j9

# configure
./autogen.sh
CONFIG_SITE=/bitcoin/depends/x86_64-pc-linux-gnu/share/config.site ./configure

# may require running this first
make dist

# reprotest
reprotest make src/bitcoind --min-cpus=9

....

make[1]: Leaving directory '/tmp/reprotest.m2nJNM/build-experiment-1'
2020-04-17 07:33:46 W: diffoscope.main: Fuzzy-matching is currently disabled as the "tlsh" module is unavailable.
=======================
Reproduction successful
=======================
No differences in ./src/bitcoind
518192b0c2469330206655b1c34179db40f6da70ac8aae2fc2e7594bdc5ad529  ./src/bitcoind
```