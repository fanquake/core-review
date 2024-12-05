# Clang Tools

The [Clang Tools](https://clang.llvm.org/docs/ClangTools.html) are standalone command line tools that provide functionality such as syntax checking, automated formatting and refactoring.

__Note:__ Before submitting any pull requests to Bitcoin Core, please read [CONTRIBUTING.md](https://github.com/bitcoin/bitcoin/blob/master/CONTRIBUTING.md). 

In particular the section on [__refactoring__](https://github.com/bitcoin/bitcoin/blob/master/CONTRIBUTING.md#refactoring), as it likely applies to changes generated with these tools:

> Trivial pull requests or pull requests that refactor the code with no clear benefits may be immediately closed by the maintainers to reduce unnecessary workload on reviewing.

There is on-going discussion in [#15465](https://github.com/bitcoin/bitcoin/issues/15465) about the potential benefit of project wide code reformatting.

## Setup

Install `clang` & LLVM.

```bash
cd bitcoin

cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
               -DCMAKE_C_COMPILER=clang \
               -DCMAKE_CXX_COMPILER=clang++
```

## clang-format

If you are going to use `clang-format` over any of the Bitcoin Core code, ensure that you use the [`clang-format`](https://github.com/bitcoin/bitcoin/blob/master/src/.clang-format) file provided under `/src`.

## clang-tidy

`clang-tidy` has been used to submit pull requests in the past, such as [#10735](https://github.com/bitcoin/bitcoin/pull/10735).

While this usage can generally be __ok__, the project is not on a crusade to _silence every warning_.

Naive usage of tools like `clang-tidy` will like result in 100's, if not 1000's of "warnings" generated for any particular file.

The majority likely being things that dont need to be fixed, or which don't point to actual bugs. i.e:

```bash
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

### run-clang-tidy

```bash
( cd ./src/ && run-clang-tidy -p ../build -j $(nproc) )
```
