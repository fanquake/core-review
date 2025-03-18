# Windows Cross Compile

Build Bitcoin Core binaries for Windows on macOS.

### Setup
Need the [mingw-w64](https://www.mingw-w64.org/) toolchain and [NSIS](https://nsis.sourceforge.io/Main_Page) (for building the installer).
```bash
brew install mingw-w64 makensis
```

### Build
```bash
# Qt cross-compilation doesn't work
make -C depends/ HOST=x86_64-w64-mingw32 NO_QT=1 -j$(nproc)

cmake -B build --toolchain depends/x86_64-w64-mingw32/toolchain.cmake

cmake --build build -j$(nproc)

file build/bin/bitcoind.exe
build/bin/bitcoind.exe: PE32+ executable (console) x86-64, for MS Windows
```

Take `build/bin/bitcoind.exe` into a Windows VM and run.

Mouting `src/` as a Shared Folder is an easy way to do this.
