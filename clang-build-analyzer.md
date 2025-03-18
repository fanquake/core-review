# Clang Build Analyser

Get [Clang Build Analyser](https://github.com/aras-p/ClangBuildAnalyzer).

```bash
export CC=clang
export CXX=clang++

cmake -B build -DCMAKE_CXX_FLAGS="-ftime-trace" -DWITH_CCACHE=NO

# start analyzer
ClangBuildAnalyzer --start .

# compile
cmake --build build -j$(nproc)

# stop analyzer
ClangBuildAnalyzer --stop . results

# analyze (results truncated)
ClangBuildAnalyzer --analyze results

Analyzing build trace from 'results'...
**** Time summary:
Compilation (449 times):
  Parsing (frontend):         1467.1 s
  Codegen & opts (backend):    707.1 s

**** Files that took longest to parse (compiler frontend):
 10754 ms: ./build/src/wallet/CMakeFiles/bitcoin_wallet.dir/rpc/spend.cpp.o
 10344 ms: ./build/src/test/CMakeFiles/test_bitcoin.dir/__/wallet/test/wallet_tests.cpp.o
 10264 ms: ./build/src/test/CMakeFiles/test_bitcoin.dir/__/wallet/test/coinselector_tests.cpp.o

**** Files that took longest to codegen (compiler backend):
 21546 ms: ./build/src/test/CMakeFiles/test_bitcoin.dir/script_tests.cpp.o
 15909 ms: ./build/src/test/CMakeFiles/test_bitcoin.dir/util_tests.cpp.o
 13415 ms: ./build/src/test/CMakeFiles/test_bitcoin.dir/main.cpp.o

**** Templates that took longest to instantiate:
  7087 ms: util::Split<std::string> (349 times, avg 20 ms)
  6328 ms: std::vector<std::string>::emplace_back<const char *&, const char *&> (345 times, avg 18 ms)
  5523 ms: std::unordered_map<BCLog::LogFlags, BCLog::Level>::unordered_map (168 times, avg 32 ms)

**** Template sets that took longest to instantiate:
 34615 ms: std::map<$>::map (2473 times, avg 13 ms)
 33644 ms: std::allocator_traits<$> (17457 times, avg 1 ms)
 30308 ms: std::map<$> (3602 times, avg 8 ms)

**** Functions that took longest to compile:
  5007 ms: script_tests::script_build::test_method() (src/test/script_tests.cpp)
  2695 ms: descriptor_tests::descriptor_test::test_method() (src/test/descriptor_tests.cpp)
  1829 ms: wallet::ismine_tests::ismine_standard::test_method() (src/wallet/test/ismine_tests.cpp)

**** Function sets that took longest to compile / optimize:
  4193 ms: tinyformat::detail::streamStateFromFormat(std::__1::basic_ostream<$>... (166 times, avg 25 ms)
  3955 ms: tinyformat::detail::formatImpl(std::__1::basic_ostream<$>&, char con... (166 times, avg 23 ms)
  1284 ms: std::__1::__tree<$>::destroy(std::__1::__tree_node<$>*) (716 times, avg 1 ms)

*** Expensive headers:
144315 ms: /src/span.h (included 355 times, avg 406 ms), included via:
  23x: args.h settings.h fs.h tinyformat.h string.h 
  20x: chainparams.h chainparams.h params.h uint256.h 
  17x: setup_common.h args.h settings.h fs.h tinyformat.h string.h 

91044 ms: /src/tinyformat.h (included 302 times, avg 301 ms), included via:
  61x: setup_common.h args.h settings.h fs.h 
  35x: args.h settings.h fs.h 
  23x: logging.h
```