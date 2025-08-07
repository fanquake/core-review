# Profile Guided Optimization

An overview of PGO is available in the [Clang Users Manual](https://clang.llvm.org/docs/UsersManual.html#profile-guided-optimization).

### Capture Profiling Data

```bash
# build minimal depends
make -C depends NO_WALLET=1 NO_QT=1 NO_ZMQ=1 NO_USDT=1 \
        CC=clang CXX=clang++ \
        AR=llvm-ar \
        NM=llvm-nm \
        RANLIB=llvm-ranlib \
        STRIP=llvm-strip

# instrumentation using -fprofile-instr-generate
# -%p is replaced with process ID during profiling
cmake -B build --toolchain=depends/aarch64-unknown-linux-gnu/toolchain.cmake \
      -DCMAKE_C_FLAGS="-fprofile-instr-generate=bitcoind-%p.profraw -flto=full" \
      -DCMAKE_CXX_FLAGS="-fprofile-instr-generate=bitcoind-%p.profraw -flto=full" \
      -DREDUCE_EXPORTS=ON \
      -DAPPEND_LDFLAGS="-flto=full -static-pie"

cmake --build build --target bitcoind

# TODO: Runtime options?
./build/bin/bitcoind
```

### Inspect profiling data

```bash
# After multiple runs you'll have raw profiling data.
llvm-profdata show bitcoind-86267.profraw --detailed-summary

Instrumentation level: Front-end
Total functions: 67454
Maximum function count: 442997952222
Maximum internal block count: 413456186977
Detailed summary:
Total number of blocks: 92925
Total count: 24437392719763
421 blocks with count >= 9366520400 account for 80 percentage of the total counts.
874 blocks with count >= 3176583698 account for 90 percentage of the total counts.
1412 blocks with count >= 1515876321 account for 95 percentage of the total counts.
2842 blocks with count >= 300666001 account for 99 percentage of the total counts.
4194 blocks with count >= 31717404 account for 99.9 percentage of the total counts.
6951 blocks with count >= 1384881 account for 99.99 percentage of the total counts.
10372 blocks with count >= 256454 account for 99.999 percentage of the total counts.

# Filter functions with --value-cutoff=x
Number of functions with maximum count (< 1000000000): 66014
Number of functions with maximum count (>= 1000000000): 1440

# Dump the functions themselves with --all-functions
Functions shown: 681
Total functions: 67454
...
  sha256_avx2.cpp:_ZN14sha256d64_avx212_GLOBAL__N_11KEj:
    Hash: 0x0000000000000018
    Counters: 1
    Function count: 8369362820
  sha256_avx2.cpp:_ZN14sha256d64_avx212_GLOBAL__N_15RoundEDv4_xS1_S1_RS1_S1_S1_S1_S2_S1_:
    Hash: 0x0000000000000000
    Counters: 1
    Function count: 6986598528
  sha256_avx2.cpp:_ZN14sha256d64_avx212_GLOBAL__N_13AddEDv4_xS1_:
    Hash: 0x0000000000000018
    Counters: 1
    Function count: 56948055710
  sha256_avx2.cpp:_ZN14sha256d64_avx212_GLOBAL__N_13AddEDv4_xS1_S1_S1_:
    Hash: 0x0000000000000018
    Counters: 1
    Function count: 9934069782
```

### Merge profiling data
```bash
# Combine the raw data into a single file using llvm-profdata
# This is required even with a single raw file as llvm-profdata alters the data format
llvm-profdata merge -output=bitcoind.profdata bitcoind-*.profraw

# To check that all your raw files are found pass --dump-input-file-list
... --dump-input-file-list
1,bitcoind-39335.profraw
1,bitcoind-47729.profraw
1,bitcoind-47916.profraw
```

### Compile using profiling data

```bash
rm -rf build

# reconfigure passing -fprofile-instr-use
# not passing the full path to bitcoind.profdata may cause issues
cmake -B build --toolchain=depends/aarch64-unknown-linux-gnu/toolchain.cmake \
      -DCMAKE_C_FLAGS="-fprofile-instr-use=/root/bitcoin/bitcoind.profdata -flto=full" \
      -DCMAKE_CXX_FLAGS="-fprofile-instr-use=/root/bitcoin/bitcoind.profdata -flto=full" \
      -DREDUCE_EXPORTS=ON \
      -DAPPEND_LDFLAGS="-flto=full -static-pie"

# recompile using the profiling data you may see warnings like:
# warning: no profile data available for file "node.cpp" [-Wprofile-instr-unprofiled]
cmake --build build --target bitcoind
```

### TODO

- PGO + more compile time optimisations
- Capture more extensive profiling data
