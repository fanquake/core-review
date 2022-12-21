# Link Time Optimization

[LLVM LTO](https://www.llvm.org/docs/LinkTimeOptimization.html)
[Clang ThinLTO](https://clang.llvm.org/docs/ThinLTO.html)

### Building with ThinLTO

```bash
# clang --version
Ubuntu clang version 14.0.0-1ubuntu1

# Minimal depends
make -C depends NO_WALLET=1 NO_QT=1 NO_ZMQ=1 NO_UPNP=1 NO_NATPMP=1 LTO=1 CC=clang-14 CXX=clang++-14

./autogen.sh

# Configure with -flto=thin and a cache.
# The cache decreases link time dramatically (30-40%)
# Note that we also have an --enable-lto in configure, which adds -flto to CXX and LD FLAGS,
# and will be enabled by LTO=1. However our flags are appended last, meaning we will get what
# we want.
CONFIG_SITE=/home/ubuntu/bitcoin/depends/x86_64-pc-linux-gnu/share/config.site \
./configure LDFLAGS="-fuse-ld=lld -flto=thin -Wl,--thinlto-cache-dir=/tmp/lto_cache" \
			CFLAGS="-flto=thin" \
			CXXFLAGS="-flto=thin"

time make -j9
```

### TODO
- Use `-fwhole-program-vtables`
