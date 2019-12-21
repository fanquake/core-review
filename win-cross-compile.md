# Windows Cross Compile

Build Bitcoin Core binaries for Windows on macOS.

### Setup
Need the [mingw-w64](https://mingw-w64.org/doku.php) toolchain and [NSIS](https://nsis.sourceforge.io/Main_Page) (for building the installer).
```bash
brew install mingw-w64 makensis
```

### Build
```bash
pushd bitcoin
# skip Qt for now. zlib build failing
make -C depends/ HOST=x86_64-w64-mingw32 -j8 NO_QT=1
./autogen.sh

# building libconsensus doesn't work, see below
./configure --prefix=/Users/michael/github/bitcoin/depends/x86_64-w64-mingw32 --with-libs=no

make -j8

# post compilation
file src/bitcoind.exe
src/bitcoind.exe: PE32+ executable (console) x86-64, for MS Windows
```

Take `src/bitcoind.exe` into a Windows VM and run.

Libconsensus doesn't link:
```bash
make
Making all in src
  CXXLD    libbitcoinconsensus.la
/usr/local/Cellar/mingw-w64/6.0.0_2/toolchain-x86_64/bin/x86_64-w64-mingw32-ld: /usr/local/Cellar/mingw-w64/6.0.0_2/toolchain-x86_64/x86_64-w64-mingw32/lib/libssp.a(ssp.o): in function `__stack_chk_fail':
/private/tmp/mingw-w64-20190802-98741-y8l1qn/mingw-w64-v6.0.0/gcc/build-x86_64/x86_64-w64-mingw32/libssp/../../../libssp/ssp.c:183: multiple definition of `__stack_chk_fail'; /usr/local/Cellar/mingw-w64/6.0.0_2/toolchain-x86_64/x86_64-w64-mingw32/lib/../lib/libssp.dll.a(d000007.o):(.text+0x0): first defined here
collect2: error: ld returned 1 exit status
make[2]: *** [libbitcoinconsensus.la] Error 1
```