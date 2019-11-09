# LLDB

[`LLDB`](https://lldb.llvm.org/) is a high performance debugger, and the default debugger in Xcode on macOS.

After compiling with `./configure --enable-debug`:

### Running:
```bash
lldb src/qt/bitcoin-qt
(lldb) target create "src/qt/bitcoin-qt"
Current executable set to 'src/qt/bitcoin-qt' (x86_64).
(lldb) run
...
```

### Passing arguments:
```bash
src/qt/bitcoin-qt -- -testnet

(lldb) target create "src/qt/bitcoin-qt"
Current executable set to 'src/qt/bitcoin-qt' (x86_64).
(lldb) settings set -- target.run-args  "-testnet"
(lldb) run
...
```

### Getting a backtrace:
After a crash, pass `bt`.
