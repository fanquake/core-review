# Core Review
Scripts, tools & info for doing [Bitcoin Core](https://github.com/bitcoin/bitcoin) development and code review. Based on using a macOS 10.14 system.

- [AppleScript](/applescript/README.md) - Scripts for UI & test automation
- [`apple-os.py`](apple-os.py) - Build `git` histories for [Apple Open Source](https://opensource.apple.com/) libraries.
- [Apt-Cacher NG](apt-cacher-ng.md) - Using Apt-Cacher NG for gitian builds.
- [`assumevalid` Updates](update-assumevalid.md) - How to review pull requests that update `assumevalid`.
- [`big-wallet.py`](big-wallet.py) - Create a wallet with lots of transactions.
- [Binary Compare](binary-compare.md) - Notes on doing binary comparisons of Bitcoin Core
- [Clang Build Analyser](clang-build-analyzer.md) - Clangs `-ftime-trace` & ClangBuildAnalyzer
- [Clang Tools](clang-tools.md) - Setting up & using Clang Tools
- [Compiler Bugs](compiler-bugs.md)
- [Compiler Defaults](compiler-defaults.md)
- [Compiler Explorer](compiler-explorer.md) - Example Compiler Explorer use case.
- [CoreRPC](https://github.com/fanquake/CoreRPC) - Swift RPC wrapper.
- [Coz](coz.md) - Profiling bitcoind with Coz
- [depends](depends.md) - notes on using the depends system
- [Determinism](determinism.md) - Notes on determinism.
- [`diffoscope`](diffoscope.md) - A tool for generating diffs.
- [Flame Graphs](/flamegraph/README.md) - Notes on producing [Flame Graphs](https://github.com/brendangregg/FlameGraph).
- [`fortify.py`](fortify.py) - Calculate _chk % replacement when using FORTIFY_SOURCE
- [Fuzzing](/fuzzing/) - Fuzzing using Clang & [libFuzzer](https://llvm.org/docs/LibFuzzer.html).
- [`github-merge.py`](github-merge.md) - Script for merging PRs from GitHub.
- [Gitian Building](/gitian-building/) - Quick setup gitian building guide.
- [gnuplot](gnuplot/README.md) - `gnuplot` usage for benchmarking and analysis.
- [Guix](guix/README.md) - Notes on setting up / using Guix.
- [Hardening](hardening.md) - Hardening in Bitcoin Core.
- [IRC](irc.md) - Where to find Bitcoin Core related discussion on IRC.
- [Link Time Optimization](lto.md) - Notes on using LTO.
- [Links](links.md) - Useful links that I would otherwise forget about.
- [LLDB](lldb.md) - Notes on using LLDB.
- [Locale Dependence](/locale-dependence/) - Locale dependence examples.
- [MacOS dylib checker](macos_dylib_check.py) - macOS dylib and dynamic linker flag auditing.
- [Mesh](mesh.md) - Running bitcoind with Mesh
- [NixOS](nixos.md) - Building on NixOS
- [Operating Systems](operating-systems.md) - OS's that Core should support.
- [Profile Guided Optimization](pgo.md) - Notes on using PGO.
- [reprotest](reprotest.md) - Using reprotest.
- [rtld-audit - Dynamic Linker Auditing](/rtld/) - linux dynamic linker auditing
- [Subtree Merges](subtree-merge.md) - How to verify subtree merges are done correctly.
- [.tbd stubs](tbd-stubs.md) - Using .tbd stubs.
- [URIs](/uri/) - URIs for testing `bitcoin:` uri handling.
- [Vagrant](/vagrant/) - Box definitions for PR review/testing.
- [Valgrind](valgrind.md) - Installing Valgrind on macOS.
- [Windows](windows.md) - Windows 10 VM setup for native builds.
- [Windows Cross Compile](/win-cross-compile.md) - Building Windows binaries on macOS

## TODO

- Add some notes LD notes for `why_live`, `dead_strip_dyibs`, `DYLD_` etc.
- glibc function usage
- CVE history