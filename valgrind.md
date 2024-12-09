# Valgrind

If you're using a Clang, you need at least Valgrind 3.20+ for proper DWARF5 support.

Installing Valgrind from source is straightforward if needed: https://valgrind.org/downloads/repository.html.

Valgrind can then be run per the [developer notes](https://github.com/bitcoin/bitcoin/blob/master/doc/developer-notes.md#valgrind-suppressions-file):
```bash
valgrind --suppressions=contrib/valgrind.supp build/src/test/test_bitcoin

valgrind --suppressions=contrib/valgrind.supp \
      --leak-check=full \
      --show-leak-kinds=all \
      build/src/test/test_bitcoin --log_level=test_suite

./build/test/functional/test_runner.py --valgrind

valgrind -v --leak-check=full build/src/bitcoind -printtoconsole
```
