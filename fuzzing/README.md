# Fuzzing using libFuzzer

Build and run the container provided by [fuzz.dockerfile](fuzz.dockerfile).

```bash
DOCKER_BUILDKIT=1 docker build --pull --no-cache -f fuzz.dockerfile -t fuzz_bitcoin .
docker run -it --name fuzz_bitcoin --workdir /bitcoin fuzz_bitcoin /bin/bash
```

### Build depends

We want to test the changes added in PR [#17860](https://github.com/bitcoin/bitcoin/pull/17860):

```bash
# build depends
make -C depends NO_QT=1 NO_WALLET=1 NO_UPNP=1 NO_ZMQ=1 CC=clang-15 CXX=clang++-15
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
CONFIG_SITE=/bitcoin/depends/x86_64-pc-linux-gnu/share/config.site ./configure \
    --enable-fuzz --with-sanitizers=fuzzer,address,undefined
make -j6
```

### Start fuzzing

PR #17860 adds the `utxo_total_supply` target, which we'll fuzz:

```bash
time FUZZ=utxo_total_supply src/test/fuzz/fuzz /qa-assets/fuzz_seed_corpus/utxo_total_supply
```

In a new window you could enter the container and tail logs:
```bash
docker exec -it fuzz_bitcoin /bin/bash
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
fuzz: test/fuzz/utxo_total_supply.cpp:86: auto utxo_total_supply_fuzz_target(FuzzBufferType)::(anonymous class)::operator()() const: Assertion 'circulation == utxo_stats.total_amount' failed.
==24424== ERROR: libFuzzer: deadly signal
    #0 0xaaaab9ded48c in __sanitizer_print_stack_trace (/bitcoin/src/test/fuzz/fuzz+0x103d48c) (BuildId: 95a77d550305f582adecb8c934189282a87532cf)
    #1 0xaaaab9d6ad64 in fuzzer::PrintStackTrace() (/bitcoin/src/test/fuzz/fuzz+0xfbad64) (BuildId: 95a77d550305f582adecb8c934189282a87532cf)
    #2 0xaaaab9d52410 in fuzzer::Fuzzer::CrashCallback() (/bitcoin/src/test/fuzz/fuzz+0xfa2410) (BuildId: 95a77d550305f582adecb8c934189282a87532cf)
    #3 0xffff9b77c79c  (linux-vdso.so.1+0x79c) (BuildId: 14511120b732425d2ab0b0bddf2450b1f31c691c)
    #4 0xffff9b2e0a0c  (/lib/aarch64-linux-gnu/libc.so.6+0x80a0c) (BuildId: 09928b270aa19314161b21f565d1a9732c2c5332)
    #5 0xffff9b29a768 in raise (/lib/aarch64-linux-gnu/libc.so.6+0x3a768) (BuildId: 09928b270aa19314161b21f565d1a9732c2c5332)
    #6 0xffff9b2874b8 in abort (/lib/aarch64-linux-gnu/libc.so.6+0x274b8) (BuildId: 09928b270aa19314161b21f565d1a9732c2c5332)
    #7 0xffff9b2941e0  (/lib/aarch64-linux-gnu/libc.so.6+0x341e0) (BuildId: 09928b270aa19314161b21f565d1a9732c2c5332)
    #8 0xffff9b294248 in __assert_fail (/lib/aarch64-linux-gnu/libc.so.6+0x34248) (BuildId: 09928b270aa19314161b21f565d1a9732c2c5332)
    #9 0xaaaaba3341a4 in utxo_total_supply_fuzz_target(Span<unsigned char const>)::$_4::operator()() const /bitcoin/src/test/fuzz/utxo_total_supply.cpp:86:9
    #10 0xaaaaba332150 in utxo_total_supply_fuzz_target(Span<unsigned char const>)::$_7::operator()() const /bitcoin/src/test/fuzz/utxo_total_supply.cpp:156:17
    #11 0xaaaaba332150 in unsigned long CallOneOf<utxo_total_supply_fuzz_target(Span<unsigned char const>)::$_5, utxo_total_supply_fuzz_target(Span<unsigned char const>)::$_6, utxo_total_supply_fuzz_target(Span<unsigned char const>)::$_7>(FuzzedDataProvider&, utxo_total_supply_fuzz_target(Span<unsigned char const>)::$_5, utxo_total_supply_fuzz_target(Span<unsigned char const>)::$_6, utxo_total_supply_fuzz_target(Span<unsigned char const>)::$_7) /bitcoin/src/./test/fuzz/util.h:42:27
    #12 0xaaaaba332150 in utxo_total_supply_fuzz_target(Span<unsigned char const>) /bitcoin/src/test/fuzz/utxo_total_supply.cpp:125:9
    #13 0xaaaaba37f6a4 in std::function<void (Span<unsigned char const>)>::operator()(Span<unsigned char const>) const /usr/bin/../lib/gcc/aarch64-linux-gnu/12/../../../../include/c++/12/bits/std_function.h:591:9
    #14 0xaaaaba37f1f8 in LLVMFuzzerTestOneInput /bitcoin/src/test/fuzz/fuzz.cpp:178:5
    #15 0xaaaab9d537b0 in fuzzer::Fuzzer::ExecuteCallback(unsigned char const*, unsigned long) (/bitcoin/src/test/fuzz/fuzz+0xfa37b0) (BuildId: 95a77d550305f582adecb8c934189282a87532cf)
    #16 0xaaaab9d3ee84 in fuzzer::RunOneTest(fuzzer::Fuzzer*, char const*, unsigned long) (/bitcoin/src/test/fuzz/fuzz+0xf8ee84) (BuildId: 95a77d550305f582adecb8c934189282a87532cf)
    #17 0xaaaab9d4433c in fuzzer::FuzzerDriver(int*, char***, int (*)(unsigned char const*, unsigned long)) (/bitcoin/src/test/fuzz/fuzz+0xf9433c) (BuildId: 95a77d550305f582adecb8c934189282a87532cf)
    #18 0xaaaab9d6b42c in main (/bitcoin/src/test/fuzz/fuzz+0xfbb42c) (BuildId: 95a77d550305f582adecb8c934189282a87532cf)
    #19 0xffff9b28777c  (/lib/aarch64-linux-gnu/libc.so.6+0x2777c) (BuildId: 09928b270aa19314161b21f565d1a9732c2c5332)
    #20 0xffff9b287854 in __libc_start_main (/lib/aarch64-linux-gnu/libc.so.6+0x27854) (BuildId: 09928b270aa19314161b21f565d1a9732c2c5332)
    #21 0xaaaab9d3a8ec in _start (/bitcoin/src/test/fuzz/fuzz+0xf8a8ec) (BuildId: 95a77d550305f582adecb8c934189282a87532cf)

NOTE: libFuzzer has rudimentary signal handlers.
      Combine libFuzzer with AddressSanitizer or similar for better crash reports.
SUMMARY: libFuzzer: deadly signal
```

I've included two of the crashers in this directory.

You can run your instance of libFuzzer, using them as input, to recreate the same
crash. i.e:

```bash
time FUZZ=utxo_total_supply src/test/fuzz/fuzz /crash-9c947d9ff00fa36eca41ad27d337743fd5fee54b
```

You should also check that removing the patch from `src/consensus/tx_check.cpp`
and using the same crash input does *not* result in a crash.

### Minimize crash input

When fuzzing you will normally want to reduce any crash inputs to be as small as
possible. This can be done using the `minimize_crash` flag.

For example, re-running the fuzzer using this flag, the 172 byte crash input,
crash-9c947..., can be reduced to < 110 bytes:

```bash
time FUZZ=utxo_total_supply src/test/fuzz/fuzz /crash-9c947d9ff00fa36eca41ad27d337743fd5fee54b -minimize_crash=1
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
docker run -it --name fuzz_bitcoin --shm-size=200m ...
```

Then, run the fuzzers, using the following:

```bash
mkdir /dev/shm/fuzz_temp_seeds

# copy the seed from qa-assets/fuzz_seed_corpus/utxo_total_supply/ into fuzz_temp_seeds
cp ../qa-assets/fuzz_seed_corpus/utxo_total_supply/f66a2... /dev/shm/fuzz_temp_seeds/f66a2..

# run the fuzzer
export TMPDIR=/dev/shm;
time FUZZ=utxo_total_supply src/test/fuzz/fuzz /dev/shm/fuzz_temp_seeds
```
