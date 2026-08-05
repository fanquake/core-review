# Darling

https://docs.darlinghq.org/build-instructions.html


Need `--privileged` or `--cap-add=SYS_ADMIN` for Podman.

```bash
mkdir -p ~/darling-prefix
podman run -it --privileged \
  -v ~/darling-prefix:/darling-prefix \
  -e DPREFIX=/darling-prefix \
  ubuntu:26.04 /bin/bash
```

```bash
apt update && apt upgrade -y

apt install -y cmake automake clang bison flex libfuse-dev libudev-dev pkg-config libc6-dev-i386 \
gcc-multilib libcairo2-dev libgl1-mesa-dev curl libglu1-mesa-dev libtiff-dev \
libfreetype6-dev git git-lfs libelf-dev libxml2-dev libegl1-mesa-dev libfontconfig1-dev \
libbsd-dev libxrandr-dev libxcursor-dev libgif-dev libavutil-dev libpulse-dev \
libavformat-dev libavcodec-dev libswresample-dev libdbus-1-dev libxkbfile-dev \
libssl-dev libstdc++-15-dev \
libcap2-bin llvm xz-utils # missing from docs?

apt install -y ccache ninja-build wget
```

```bash
GIT_CLONE_PROTECTION_ACTIVE=false git clone --recursive https://github.com/darlinghq/darling.git
```

```bash
cmake -B build -G Ninja -DTARGET_i386=OFF -DCOMPONENTS=core,system
cmake --build build
cmake --install build
```

```bash
wget https://bitcoincore.org/bin/bitcoin-core-31.1/bitcoin-31.1-x86_64-apple-darwin.tar.gz
tar xf bitcoin-31.1-x86_64-apple-darwin.tar.gz

darling exec bitcoin-31.1/bin/bitcoin --help
dyld: Symbol not found: __ZNKSt3__14__fs10filesystem4path10__filenameEv
  Referenced from: /Volumes/SystemRoot/bitcoin-31.1/bin/bitcoin (which was built for Mac OS X 14.0)
  Expected in: /usr/lib/libc++.1.dylib

abort_with_payload: reason: Symbol not found: __ZNKSt3__14__fs10filesystem4path10__filenameEv
  Referenced from: /Volumes/SystemRoot/bitcoin-31.1/bin/bitcoin (which was built for Mac OS X 14.0)
  Expected in: /usr/lib/libc++.1.dylib
; code: 4
```
