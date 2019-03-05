# LLDB

[`LLDB`](https://lldb.llvm.org/) is a high performance debugger, and the default debugger in Xcode on macOS.

After compiling:

### Running:
```
lldb src/qt/bitcoin-qt
(lldb) target create "src/qt/bitcoin-qt"
Current executable set to 'src/qt/bitcoin-qt' (x86_64).
(lldb) run
Process 46942 launched: 'bitcoin/src/qt/bitcoin-qt' (x86_64)
...
```

### Passing arguments:
```
src/qt/bitcoin-qt -- -testnet

(lldb) target create "src/qt/bitcoin-qt"
Current executable set to 'src/qt/bitcoin-qt' (x86_64).
(lldb) settings set -- target.run-args  "-testnet"
(lldb) run
Process 46978 launched: 'bitcoin/src/qt/bitcoin-qt' (x86_64)
...
```

### Getting a backtrace:
After a crash, pass `bt`.

### Exiting
i.e after stopping the binary

```
Process 46978 exited with status = 0 (0x00000000) 
(lldb) exit
```