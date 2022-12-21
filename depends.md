# depends

### shortcuts

Build a specific stage of a specific package
```bash
make -C depends boost_configured
make -C depends libevent_built
make -C depends qt_staged
# etc etc
```

Dump out depends variables using `print-` (from in `bitcoin/depends/`):

```bash
# make print-build_os
build_os = linux

# make print-host_os
host_os = linux

# make print-build_os HOST=x86_64-w64-mingw32
build_os = linux

# make print-host_os HOST=x86_64-w64-mingw32
host_os = mingw32

# make print-libevent_cflags
libevent_cflags = -pipe -std=c11 -O2

# make print-boost_cxxflags
boost_cxxflags = -pipe -std=c++17 -O2

# make print-libevent_cflags DEBUG=1
# (ignoring the ENV output)
libevent_cflags = -pipe -std=c11 -O1

# make print-boost_cxx
boost_cxx = g++ -m64

# make print-boost_cxx HOST=x86_64-w64-mingw32
boost_cxx = x86_64-w64-mingw32-g++-posix
```