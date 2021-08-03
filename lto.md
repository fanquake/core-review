# Link Time Optimization

[LLVM LTO](https://www.llvm.org/docs/LinkTimeOptimization.html)
[Clang ThinLTO](https://clang.llvm.org/docs/ThinLTO.html)

### Building with ThinLTO

```bash
# build minimal depends
make -C depends NO_WALLET=1 NO_QT=1 NO_ZMQ=1 NO_UPNP=1

./autogen.sh

# configure with -flto=thin and a cache. 
# The cache increases link time dramatically (30-40%)
CONFIG_SITE=/Users/michael/github/fanquake-bitcoin/depends/x86_64-apple-darwin20.6.0/share/config.site ./configure \
LDFLAGS="-flto=thin -Wl,-cache_path_lto,/tmp" CFLAGS="-flto=thin" CXXFLAGS="-flto=thin"

gmake check -j8
```

### TODO
- Use `-fwhole-program-vtables`
