# Clang Tools

The [Clang Tools](https://clang.llvm.org/docs/ClangTools.html) are standalone command line tools that provide functionality such as syntax checking, automated formatting and refactoring.

__Note:__ Before submitting any pull requests to Bitcoin Core, please read [CONTRIBUTING.md](https://github.com/bitcoin/bitcoin/blob/master/CONTRIBUTING.md). In particular the section on [__refactoring__](https://github.com/bitcoin/bitcoin/blob/master/CONTRIBUTING.md#refactoring), as it likely applies to changes generated with these tools:

> Trivial pull requests or pull requests that refactor the code with no clear benefits may be immediately closed by the maintainers to reduce unnecessary workload on reviewing.

There is on-going discussion in [#15465](https://github.com/bitcoin/bitcoin/issues/15465) about the potential benefit of project wide code reformatting.

## Setup

An easy way to get started with `clang-tidy` (and other clang related tools) is the following:

```bash
brew install llvm

# symlink the tools you want into /usr/local/bin
# Note: check all available tools with
# ls /usr/local/opt/llvm/bin/

ln -s /usr/local/opt/llvm/bin/clang-format /usr/local/bin/clang-format
ln -s /usr/local/opt/llvm/bin/clang-tidy /usr/local/bin/clang-tidy

clang-tidy -version

LLVM (http://llvm.org/):
  LLVM version 7.0.1
  Optimized build.
  Default target: x86_64-apple-darwin18.2.0
  Host CPU: skylake
```

__Note:__ You might already have `clang-format` installed via brew, as it is available as a stand-alone formula. 
The stand-alone version is currently newer (8.0.0 vs 7.0.1) than the one installed with `llvm`.


## clang-format

If you are going to use `clang-format` over any of the Bitcoin Core code, ensure that you use the [`clang-format`](https://github.com/bitcoin/bitcoin/blob/master/src/.clang-format) file provided under `/src`.

## clang-tidy

`clang-tidy` has been used to submit pull requests in the past, such as [#10735](https://github.com/bitcoin/bitcoin/pull/10735).

While this usage can generally be __ok__, the project is not on a crusade to _silence all the warnings_.

Naive usage of tools like `clang-tidy` will like result in 100's, if not 1000's of "warnings" generated for any particular file.

The majority likely being things that dont need to be fixed, or which dont point to actual bugs. i.e:

```bash
pushd bitcoin
clang-tidy -checks=* src/init.cpp
5981 warnings and 3 errors generated.

# some cherry-picked examples
src/init.cpp:10:10: error: 'init.h' file not found with <angled> include; use "quotes" instead [clang-diagnostic-error]
src/init.cpp:21:1: warning: #includes are not sorted properly [llvm-include-order]
src/init.cpp:52:10: warning: inclusion of deprecated C++ header 'stdint.h'; consider using 'cstdint' instead [modernize-deprecated-headers]
src/init.cpp:313:30: warning: all parameters should be named in a function [readability-named-parameter]
src/init.cpp:592:61: warning: parameter 'pBlockIndex' is unused [misc-unused-parameters] # these certainly are used
src/init.cpp:1106:5: warning: missing username/bug in TODO [google-readability-todo]
src/util/system.h:17:10: error: 'attributes.h' file not found [clang-diagnostic-error]
Suppressed 5947 warnings (5947 in non-user code).
```

## Generating a compilation database

I'm using [`compiledb`](https://github.com/nickdiego/compiledb). There are tools like [Build EAR](https://github.com/rizsotto/Bear), or if using Cmake, you could pass `-DCMAKE_EXPORT_COMPILE_COMMANDS`. However, Build EAR didn't work for me (see [#232](https://github.com/rizsotto/Bear/issues/232) and [#215](https://github.com/rizsotto/Bear/issues/215)), and Core doesn't use CMake.

### Install

__Note:__ Python >= 3.6 is required.

```bash
pip3 install compiledb
```

### Usage

```bash
pushd bitcoin
./autogen.sh && ./configure

# When calling make use compiledb
compiledb make -j6
```

This should generate a `compile_commands.json` file, which will contain output like this:

```json
[
 {
  "directory": "/Users/michael/github/bitcoin/src",
  "arguments": [
   "g++",
   "-std=c++11",
   "-DHAVE_CONFIG_H",
   "-I.",
   "-I../src/config",
   "-U_FORTIFY_SOURCE",
   "-D_FORTIFY_SOURCE=2",
   "-I.",
   "-DBOOST_SP_USE_STD_ATOMIC",
   "-DBOOST_AC_USE_STD_ATOMIC",
   "-pthread",
   "-I/usr/local/include",
   "-I./leveldb/include",
   "-I./leveldb/helpers/memenv",
   "-I/usr/local/Cellar/openssl/1.0.2q/include",
   "-I/usr/local/Cellar/openssl/1.0.2q/include",
   "-I./secp256k1/include",
   "-I./univalue/include",
   "-Qunused-arguments",
   "-DHAVE_BUILD_INFO",
   "-D__STDC_FORMAT_MACROS",
   "-I/usr/local/opt/berkeley-db@4/include",
   "-DMAC_OSX",
   "-Wstack-protector",
   "-fstack-protector-all",
   "-Wall",
   "-Wextra",
   "-Wformat",
   "-Wvla",
   "-Wformat-security",
   "-Wthread-safety-analysis",
   "-Wrange-loop-analysis",
   "-Wredundant-decls",
   "-Wno-unused-parameter",
   "-Wno-self-assign",
   "-Wno-unused-local-typedef",
   "-Wno-deprecated-register",
   "-Wno-implicit-fallthrough",
   "-g",
   "-O2",
   "-MT",
   "bitcoind-bitcoind.o",
   "-MD",
   "-MP",
   "-MF",
   ".deps/bitcoind-bitcoind.Tpo",
   "-c",
   "-o",
   "bitcoind-bitcoind.o",
   "bitcoind.cpp"
  ],
  "file": "bitcoind.cpp"
 },
 ....
]
```
