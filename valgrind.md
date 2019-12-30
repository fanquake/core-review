# Valgrind

Latest [Valgrind](http://valgrind.org) (3.15) only supports macOS 10.12 (preliminary support for 10.13). See also, the `brew` [Valgrind formula](https://github.com/Homebrew/homebrew-core/blob/master/Formula/valgrind.rb).

However a Valgrind fork is available at [sowson/valgrind](https://github.com/sowson/valgrind) which has some support for macOS 10.14.x. See [this commit](https://github.com/sowson/valgrind/commit/3e79a0a5fa3f2a73cbcd23150ad70734b5348b14). 

It can be installed with:
```bash
brew install --HEAD https://raw.githubusercontent.com/sowson/valgrind/master/valgrind.rb
```

Valgrind can then be run per the Bitcoin Core [developer notes](https://github.com/bitcoin/bitcoin/blob/master/doc/developer-notes.md#valgrind-suppressions-file):
```bash
valgrind --suppressions=contrib/valgrind.supp src/test/test_bitcoin
valgrind --suppressions=contrib/valgrind.supp --leak-check=full \
      --show-leak-kinds=all src/test/test_bitcoin --log_level=test_suite
valgrind -v --leak-check=full src/bitcoind -printtoconsole
./test/functional/test_runner.py --valgrind
```
