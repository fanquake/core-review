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

./configure --prefix=/Users/michael/github/bitcoin/depends/x86_64-w64-mingw32

make -j8

file src/bitcoind.exe
src/bitcoind.exe: PE32+ executable (console) x86-64, for MS Windows
```

Take `src/bitcoind.exe` into a Windows VM and run.

Mouting `src/` as a Shared Folder is an easy way to do this.
