# Epoch Sanity

```bash
DOCKER_BUILDKIT=1 docker build --no-cache -f epoch.dockerfile -t epoch .

docker run -it epoch /bin/bash
```

```bash
./autogen.sh
./configure CC=clang CXX="clang++ -stdlib=libc++ -lc++abi -Wl,-rpath,/usr/local/lib/aarch64-unknown-linux-gnu"
make src/bitcoind -j9
```

```bash
./src/bitcoind # runs fine
```

```bash
cd ../llvm-project
vim libcxx/src/chrono.cpp
```

Mess with libstdc++'s `from_time_t`:
```cpp
system_clock::time_point
system_clock::from_time_t(time_t t) noexcept
{
	// i.e time_point(seconds(42))
    return system_clock::time_point(seconds(t));
}
```

Rebuild and reinstall LLVM
```basht
cmake --build build --target install -j9
cd ../bitcoin
```

Re-run bitcoind
No need to recompile bitcoind, as we're loading libc++ dynamically
```bash
./src/bitcoind

Error: Clock epoch mismatch. Aborting.
Error: Initialization sanity check failed. Bitcoin Core is shutting down.
```