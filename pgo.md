# Profile Guided Optimization

An overview of PGO is available in the [Clang Users Manual](https://clang.llvm.org/docs/UsersManual.html#profile-guided-optimization).

### Capture Profiling Data

```bash
# build minimal depends
make -C depends NO_WALLET=1 NO_QT=1 NO_ZMQ=1 NO_UPNP=1

./autogen.sh

# instrument using -fprofile-instr-generate
# -%p is replaced with process ID during profiling
CXXFLAGS="-fprofile-instr-generate=bitcoind-%p.profraw" ./configure \
--prefix=/Users/michael/github/bitcoin/depends/x86_64-apple-darwin18.7.0 \
--disable-bench --disable-man --with-utils=no --with-libs=no

gmake src/bitcoind -j8

# Generate profiling data using bitcoin.conf with:
# assumevalid=0
# par=8
# reindex-chainstate=1
src/bitcoind
```

### Merge profiling data

```bash
# After multiple runs you'll have raw profiling data.
# Combine the raw data into a single file using llvm-profdata
#
# This is required even with a single raw file as llvm-profdata alters the data format
/usr/local/opt/llvm/bin/llvm-profdata merge -output=bitcoind.profdata bitcoind-*.profraw

# To check that all your raw files are found pass --dump-input-file-list
... --dump-input-file-list
1,bitcoind-39335.profraw
1,bitcoind-47729.profraw
1,bitcoind-47916.profraw
1,bitcoind-48019.profraw
```

### Compile using profiling data

```bash
gmake clean

# reconfigure passing -fprofile-instr-use
# not passing the full path to bitcoind.profdata may cause isses
CXXFLAGS="-fprofile-instr-use=/Users/michael/github/bitcoin/bitcoind.profdata" ./configure --prefix=/Users/michael/github/bitcoin/depends/x86_64-apple-darwin18.7.0 --disable-bench --disable-man --with-utils=no --with-libs=no

# recompile using the profiling data you may see warnings like:
# warning: no profile data available for file "node.cpp" [-Wprofile-instr-unprofiled]
gmake src/bitcoind -j8
```

### TODO

- PGO + LTO
- PGO + more compile time optimisations
- Capture more extensive profiling data

