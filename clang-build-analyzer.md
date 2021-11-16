# Clang Build Analyser

Build [Clang Build Analyser](https://github.com/aras-p/ClangBuildAnalyzer).

```bash
./autogen.sh
./configure CC=/usr/local/opt/llvm/bin/clang CXX=/usr/local/opt/llvm/bin/clang++ CXXFLAGS="-ftimetrace"

# start analyzer
ClangBuildAnalyzer --start .

# compile
make -j8

# stop analyzer
ClangBuildAnalyzer --stop . results

# analyze (results truncated)
ClangBuildAnalyzer --analyze results

Analyzing build trace from 'results'...
**** Time summary:
Compilation (957 times):
  Parsing (frontend):         2386.2 s
  Codegen & opts (backend):   1898.8 s

**** Files that took longest to parse (compiler frontend):
 18241 ms: src/wallet/libbitcoin_wallet_a-wallet.o
 16566 ms: src/wallet/test/test_test_bitcoin-wallet_tests.o
 16493 ms: src/qt/test/test_bitcoin_qt-wallettests.o

**** Files that took longest to codegen (compiler backend):
 50505 ms: src/test/test_bitcoin-script_tests.o
 48555 ms: src/wallet/libbitcoin_wallet_a-wallet.o
 48209 ms: src/wallet/libbitcoin_wallet_a-rpcwallet.o

**** Templates that took longest to instantiate:
 21589 ms: boost::multi_index::multi_index_container<CTxMemPoolEntry, boost::mu... (140 times, avg 154 ms)
 18124 ms: std::__1::__function::__func<NodeContext::(lambda at ./node/context.... (360 times, avg 50 ms)
 17556 ms: std::__1::make_shared<std::__1::__fs::filesystem::filesystem_error::... (251 times, avg 69 ms)

**** Template sets that took longest to instantiate:
 76891 ms: std::__1::allocator_traits<$> (31707 times, avg 2 ms)
 67035 ms: std::__1::decay<$> (89857 times, avg 0 ms)
 61363 ms: std::__1::map<$> (3625 times, avg 16 ms)

**** Functions that took longest to compile:
 47643 ms: sha256d64_sse41::Transform_4way(unsigned char*, unsigned char const*) (crypto/sha256_sse41.cpp)
 46056 ms: sha256d64_avx2::Transform_8way(unsigned char*, unsigned char const*) (crypto/sha256_avx2.cpp)
 23579 ms: script_tests::script_build::test_method() (test/script_tests.cpp)

 **** Function sets that took longest to compile / optimize:
 12786 ms: tinyformat::detail::streamStateFromFormat(std::__1::basic_ostream<$>... (208 times, avg 61 ms)
 11361 ms: std::__1::basic_stringbuf<$>::str() const (185 times, avg 61 ms)
 11087 ms: tinyformat::detail::formatImpl(std::__1::basic_ostream<$>&, char con... (208 times, avg 53 ms)

*** Expensive headers:
280884 ms: test/util/setup_common.h (included 102 times, avg 2753 ms), included via:
  test_test_bitcoin-wallet_test_fixture.o wallet_test_fixture.h  (5192 ms)
  qt_test_test_bitcoin_qt-wallet_test_fixture.o wallet_test_fixture.h  (4947 ms)
  test_bitcoin-base64_tests.o  (4807 ms)
  test_bitcoin-getarg_tests.o  (4754 ms)
  test_bitcoin-base32_tests.o  (4703 ms)
  test_bitcoin-blockfilter_tests.o  (4643 ms)
  ...

242485 ms: fs.h (included 250 times, avg 969 ms), included via:
  test_test_bitcoin-init_test_fixture.o  (2152 ms)
  test_bitcoin-fs_tests.o  (2060 ms)
  libbitcoin_wallet_a-walletutil.o walletutil.h  (1972 ms)
  libbitcoin_wallet_a-salvage.o  (1907 ms)
  libtest_util_a-net.o net.h net.h addrdb.h  (1862 ms)
  libbitcoin_util_a-fs.o  (1861 ms)
  ...

193370 ms: txmempool.h (included 140 times, avg 1381 ms), included via:
  libbitcoin_server_a-txmempool.o  (2826 ms)
  libbitcoin_server_a-rbf.o rbf.h  (2821 ms)

```