# Link Time Optimization

[LLVM LTO](https://www.llvm.org/docs/LinkTimeOptimization.html)
[Clang ThinLTO](https://clang.llvm.org/docs/ThinLTO.html)

### Building with ThinLTO

```bash
# Minimal depends
make -C depends NO_WALLET=1 NO_QT=1 NO_ZMQ=1 LTO=1 \
		AR=llvm-ar \
		NM=llvm-nm \
		RANLIB=llvm-ranlib \
		STRIP=llvm-strip \
		CC=clang CXX=clang++ \
		CFLAGS="-flto=thin" \
		CXXFLAGS="-flto=thin" \
		LDFLAGS="-fuse-ld=lld -flto=thin -Wl,--thinlto-cache-dir=/tmp/lto_cache"

# Configure with -flto=thin and a cache.
# The cache decreases link time dramatically (30-40%)
# Note that we also have an --enable-lto in configure, which adds -flto to CXX and LD FLAGS,
# and will be enabled by LTO=1. However our flags are appended last, meaning we will get what
# we want.
cmake -B build --toolchain=depends/x86_64-pc-linux-gnu/toolchain.cmake

time cmake --build build -j17
```
