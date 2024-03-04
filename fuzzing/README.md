# Fuzzing using libFuzzer

Build and run the container provided by [fuzz.dockerfile](fuzz.dockerfile).

```bash
DOCKER_BUILDKIT=1 docker build --pull --no-cache -f fuzz.dockerfile -t fuzz-bitcoin .
docker run -it --name fuzz-bitcoin --workdir /bitcoin fuzz-bitcoin /bin/bash
```

### Checkout #17860 and build depends

We want to test the changes in PR [#17860](https://github.com/bitcoin/bitcoin/pull/17860):

```bash
# checkout the PR to fuzz #17860
git fetch origin pull/17860/head:17860
git checkout 17860

# build depends
make -C depends NO_QT=1 NO_WALLET=1 NO_UPNP=1 NO_ZMQ=1
```

### Patch Bitcoin Core

Apply the diff below to `src/consensus/tx_check.cpp`, so the fuzzer has
something to find.

See [#17080](https://github.com/bitcoin/bitcoin/pull/17080) and [`CVE-2018-17144`](https://bitcoincore.org/en/2018/09/20/notice/) for more details.

```diff
diff --git a/src/consensus/tx_check.cpp b/src/consensus/tx_check.cpp
@@ -36,12 +36,6 @@ bool CheckTransaction(const CTransaction& tx, TxValidationState& state)
     // Failure to run this check will result in either a crash or an inflation bug, depending on the implementation of
     // the underlying coins database.
-    std::set<COutPoint> vInOutPoints;
-    for (const auto& txin : tx.vin) {
-        if (!vInOutPoints.insert(txin.prevout).second)
-            return state.Invalid(TxValidationResult::TX_CONSENSUS, "bad-txns-inputs-duplicate");
-    }
```

### Configure for fuzzing and compile

```bash
./autogen.sh
./configure --prefix=/bitcoin/depends/x86_64-pc-linux-gnu \
    --enable-fuzz --with-sanitizers=fuzzer,address,undefined \
    CC=clang-11 CXX=clang++-11
make -j6
```

### Start fuzzing

PR #17860 adds the `utxo_total_supply` target, which we'll fuzz:

```bash
time src/test/fuzz/utxo_total_supply \
-jobs=6 \
-print_final_stats=1 \
-workers=6 \
/qa-assets/fuzz_seed_corpus/utxo_total_supply
```

In a new window you could enter the container and tail logs:
```bash
docker exec -it fuzz-bitcoin /bin/bash
tail -f fuzz-*.log
...
==> fuzz-4.log <==
#4814	NEW    cov: 48490 ft: 244756 corp: 2125/68Kb lim: 150 exec/s: 3 rss: 609Mb L: 150/150 MS: 4 ShuffleBytes-CrossOver-ChangeBit-CrossOver-
#4815	RELOAD cov: 48490 ft: 245135 corp: 2126/68Kb lim: 150 exec/s: 3 rss: 609Mb

==> fuzz-0.log <==
#4883	NEW    cov: 48331 ft: 245548 corp: 2194/69Kb lim: 151 exec/s: 3 rss: 613Mb L: 128/151 MS: 3 ChangeBit-ChangeByte-InsertByte-

==> fuzz-4.log <==
#4837	NEW    cov: 48490 ft: 245146 corp: 2127/68Kb lim: 150 exec/s: 3 rss: 609Mb L: 76/150 MS: 1 ChangeBit-

==> fuzz-1.log <==
#4815	NEW    cov: 48515 ft: 245185 corp: 2152/68Kb lim: 150 exec/s: 3 rss: 604Mb L: 59/150 MS: 1 ChangeBinInt-

==> fuzz-5.log <==
#4834	NEW    cov: 48285 ft: 244697 corp: 2135/67Kb lim: 150 exec/s: 3 rss: 608Mb L: 150/150 MS: 3 ChangeASCIIInt-InsertByte-CrossOver-

==> fuzz-2.log <==
#4883	RELOAD cov: 48499 ft: 245244 corp: 2102/67Kb lim: 150 exec/s: 3 rss: 611Mb
```

### Crash

Eventually, libFuzzer will crash (I've shortend some of the output).

Depending on your hardware, this could take many hours.

```bash
#22638	NEW    cov: 48625 ft: 251339 corp: 2317/93Kb lim: 185 exec/s: 2 rss: 683Mb L: 121/192 MS: 2 ChangeByte-InsertByte-
#23497	RELOAD cov: 48632 ft: 251363 corp: 2318/93Kb lim: 192 exec/s: 2 rss: 683Mb
#23557	NEW    cov: 48632 ft: 251369 corp: 2319/94Kb lim: 192 exec/s: 2 rss: 683Mb L: 176/192 MS: 2 ShuffleBytes-CopyPart-
utxo_total_supply: test/fuzz/utxo_total_supply.cpp:77: auto test_one_input(const std::vector<uint8_t> &)::(anonymous class)::operator()() const: Assertion "circulation == utxo_stats.nTotalAmount" failed.
==16247== ERROR: libFuzzer: deadly signal
    #0 0x561d1c715d91  (/bitcoin/src/test/fuzz/utxo_total_supply+0x208bd91)
    #1 0x561d1c6603c8  (/bitcoin/src/test/fuzz/utxo_total_supply+0x1fd63c8)
    #2 0x561d1c645b33  (/bitcoin/src/test/fuzz/utxo_total_supply+0x1fbbb33)
    #3 0x7f510df1551f  (/lib/x86_64-linux-gnu/libpthread.so.0+0x1351f)
    #4 0x7f510dc0b080  (/lib/x86_64-linux-gnu/libc.so.6+0x3a080)
    #5 0x7f510dbf6534  (/lib/x86_64-linux-gnu/libc.so.6+0x25534)
    #6 0x7f510dbf640e  (/lib/x86_64-linux-gnu/libc.so.6+0x2540e)
    #7 0x7f510dc03b91  (/lib/x86_64-linux-gnu/libc.so.6+0x32b91)
    #8 0x561d1c7497c9  (/bitcoin/src/test/fuzz/utxo_total_supply+0x20bf7c9)
    #9 0x561d1c746e2d  (/bitcoin/src/test/fuzz/utxo_total_supply+0x20bce2d)
    #10 0x561d1c73f8ca  (/bitcoin/src/test/fuzz/utxo_total_supply+0x20b58ca)
    #11 0x561d1c6470c1  (/bitcoin/src/test/fuzz/utxo_total_supply+0x1fbd0c1)
    #12 0x561d1c646905  (/bitcoin/src/test/fuzz/utxo_total_supply+0x1fbc905)
    #13 0x561d1c648ba7  (/bitcoin/src/test/fuzz/utxo_total_supply+0x1fbeba7)
    #14 0x561d1c6498c5  (/bitcoin/src/test/fuzz/utxo_total_supply+0x1fbf8c5)
    #15 0x561d1c6376a8  (/bitcoin/src/test/fuzz/utxo_total_supply+0x1fad6a8)
    #16 0x561d1c660af2  (/bitcoin/src/test/fuzz/utxo_total_supply+0x1fd6af2)
    #17 0x7f510dbf7bba  (/lib/x86_64-linux-gnu/libc.so.6+0x26bba)
    #18 0x561d1c60af49  (/bitcoin/src/test/fuzz/utxo_total_supply+0x1f80f49)

NOTE: libFuzzer has rudimentary signal handlers.
      Combine libFuzzer with AddressSanitizer or similar for better crash reports.
SUMMARY: libFuzzer: deadly signal
MS: 5 CrossOver-ShuffleBytes-ChangeASCIIInt-ChangeBit-EraseBytes-; base unit: d1a5c27d68809f2e9c739d76c69065ff17ae7d6f
0x8f,0x7a,0x5,0xcb,0x7a,0x2,0x2f,0x5,0x5, <trimmed> 0x89,0x89,0x89,0x89,0x0,0x0,0x0,
\x8fz\x05\xcbz\x02/\x05\x052\x025 <trimmed> \x89\x89\x89\x89\x00\x00\x00
artifact_prefix='./'; Test unit written to ./crash-9c947d9ff00fa36eca41ad27d337743fd5fee54b
Base64: j3oFy3oCLwUFMgI1BQIFHS96ekF3uYB6QOLIyAcFjwABenoFZHEFBQFNIMpNBTMFPwXHuYB6CpWVBVBQenp6enpieoB6enoFBQUAplmmDQA9BQV6enoCj/j4+Pj4+Pj4+PgFBQUFBQVQUHp6j4+PjwUFBXpZenp6BVBQenqPj4+PBQUFell6enpZUFCqenp6Anp6eoB6AuZZUFBpenqPelCPeo+JiYmJiQAAAA==
stat::number_of_executed_units: 23579
stat::average_exec_per_sec:     2
stat::new_units_added:          92
stat::slowest_unit_time_sec:    0
stat::peak_rss_mb:              683
```

I've included two of the crashers in this directory.

You can run your instance of libFuzzer, using them as input, to recreate the same
crash. i.e:

```bash
time src/test/fuzz/utxo_total_supply \
-print_final_stats=1 \
-jobs=6 \
-workers=6 \
crash-9c947d9ff00fa36eca41ad27d337743fd5fee54b
```

You should also check that removing the patch from `src/consensus/tx_check.cpp`
and using the same crash input does *not* result in a crash.

### Minimize crash input

When fuzzing you will normally want to reduce any crash inputs to be as small as
possible. This can be done using the `minimize_crash` flag.

For example, re-running the fuzzer using this flag, the 172 byte crash input,
crash-9c947..., can be reduced to < 110 bytes:

```bash
src/test/fuzz/utxo_total_supply \
-print_final_stats=1 \
-minimize_crash=1 \
crash-9c947d9ff00fa36eca41ad27d337743fd5fee54b
...
CRASH_MIN: minimizing crash input: 'crash-9c947d9ff00fa36eca41ad27d337743fd5fee54b' (172 bytes)
...
CRASH_MIN: minimizing crash input: './minimized-from-9c947d9ff00fa36eca41ad27d337743fd5fee54b' (170 bytes)
...
CRASH_MIN: minimizing crash input: './minimized-from-91553b55b90d77a51c310844101bf6d31bb5d4cf' (150 bytes)
...
CRASH_MIN: minimizing crash input: './minimized-from-e3ac2a491fb8215065377867b8d6975ecf72df0e' (139 bytes)
...
CRASH_MIN: minimizing crash input: './minimized-from-faf5cd0c652b9e4f7ae087e0b24825f76e538dd9' (126 bytes)
...
CRASH_MIN: minimizing crash input: 'minimized-from-6db724bc2201eb512f7397e0b8d06a5b3b6acf17' (108 bytes)
CRASH_MIN: 'minimized-from-6db724bc2201eb512f7397e0b8d06a5b3b6acf17' (108 bytes) caused a crash. Will try to minimize it further
...
INFO: Done MinimizeCrashInputInternalStep, no crashes found
CRASH_MIN: failed to minimize beyond minimized-from-6db724bc2201eb512f7397e0b8d06a5b3b6acf17 (108 bytes), exiting
```

### Faster fuzzing using /dev/shm as TMPDIR

`/dev/shm` can be used to speed up the fuzzing process. This requires passing
`--shm-size=Nm` to `docker` when starting the container. By default `/dev/shm` is
only 64mb, which is not large enough to hold the seeds and data directories.

You need `~20mb` per datadir (worker) and overhead for the seeds directory. So
we'll just use 200m.

```bash
docker run -it --name fuzz-bitcoin --shm-size=200m ...
```

Then, run the fuzzers, using the following:

```bash
mkdir /dev/shm/fuzz_temp_seeds

# copy the seed from qa-assets/fuzz_seed_corpus/utxo_total_supply/ into fuzz_temp_seeds
cp ../qa-assets/fuzz_seed_corpus/utxo_total_supply/f66a2... /dev/shm/fuzz_temp_seeds/f66a2..

# run the fuzzer
export TMPDIR=/dev/shm;
time src/test/fuzz/utxo_total_supply \
-print_final_stats=1 \
-jobs=6 \
-workers=6 \
/dev/shm/fuzz_temp_seeds
```
