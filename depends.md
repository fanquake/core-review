# depends

### shortcuts

Build a specific stage of a specific package
```bash
make -C depends boost_configured
make -C depends libevent_built
make -C depends qt_staged
# etc etc
```

Dump out depends variables using `print-`:

```bash
# make -C depends print-build_os
build_os = darwin

# make -C depends print-host_os
host_os = darwin

# make -C depends print-build_os HOST=x86_64-w64-mingw32
build_os = darwin

# make -C depends print-host_os HOST=x86_64-w64-mingw32
host_os = mingw32

# make -C depends print-boost_cxxflags
boost_cxxflags = -std=c++17 -fvisibility=hidden

# make -C depends print-boost_cflags
boost_cflags = -pipe -O2

# make -C depends print-boost_cflags DEBUG=1
boost_cflags = -pipe -O1

# make -C depends print-boost_cxx
boost_cxx = /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++ \
 -mmacosx-version-min=10.14 -stdlib=libc++ \
 --sysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk

# make -C depends print-boost_cxx HOST=x86_64-w64-mingw32
boost_cxx = x86_64-w64-mingw32-g++
```