# Valgrind

If you're using a recent Clang (14+), you'll want a recent Valgrind (3.20+) for proper DWARF5 support. 

Installing Valgrind from source is straightforward: https://valgrind.org/downloads/repository.html.

You may want to `--enable-lto` when configuring.

Valgrind can then be run per the [developer notes](https://github.com/bitcoin/bitcoin/blob/master/doc/developer-notes.md#valgrind-suppressions-file):
```bash
valgrind --suppressions=contrib/valgrind.supp src/test/test_bitcoin

valgrind --suppressions=contrib/valgrind.supp \
      --leak-check=full \
      --show-leak-kinds=all \
      src/test/test_bitcoin --log_level=test_suite

./test/functional/test_runner.py --valgrind

valgrind -v --leak-check=full src/bitcoind -printtoconsole
```

### macOS Support (old)

Latest [Valgrind](http://valgrind.org) (3.20) only supports macOS 10.12 (preliminary support for 10.13).

A Valgrind fork is available at [sowson/valgrind](https://github.com/sowson/valgrind) which has some support for macOS 10.15.x.

It can be installed with:
```bash
brew install --HEAD https://raw.githubusercontent.com/sowson/valgrind/master/valgrind.rb
```
