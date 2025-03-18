# LLDB

[`LLDB`](https://lldb.llvm.org/) is a high performance debugger, and the default debugger on macOS.

After compiling with `cmake -B build -DCMAKE_BUILD_TYPE=Debug`:

### Running:
```bash
lldb build/bin/bitcoin-qt
(lldb) target create "build/bin/bitcoind"
Current executable set to '/build/bin/bitcoind' (arm64).
(lldb) run
...
```

### Passing arguments:
```bash
src/qt/bitcoin-qt -- -testnet

(lldb) target create "build/bin/bitcoind"
Current executable set to '/build/bin/bitcoind' (arm64).
(lldb) settings set -- target.run-args  "-testnet"
(lldb) run
...
```

### Getting a backtrace:
After a crash, pass `bt`.
