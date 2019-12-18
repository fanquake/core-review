# Docker

## General Usage

The dockerfiles in this directory can be used to run `depends` builds for various `HOST`s.
The images will contain all the dependencies required for cross compiling.

For example, to build the Debian image and use it for a build targeting the `RISCV-64` host:

```bash
# Build container
DOCKER_BUILDKIT=1 docker build --pull --no-cache -f debian.dockerfile -t debian-depends .

# Run with a Bash shell
docker run -it --name debian-depends --workdir /bitcoin debian-depends /bin/bash

# Inside the container: build depends for RISCV-64 bit, skipping Qt packages
make HOST=riscv64-linux-gnu NO_QT=1 -C depends/ -j5
./autogen.sh
./configure --prefix=/bitcoin/depends/riscv64-linux-gnu
make -j5
```

### macOS SDK
Cross compiling for macOS requires the macOSX10.11 SDK and using the `debian9.dockerfile`.
There are [notes in the bitcoin/bitcoin repo](https://github.com/bitcoin/bitcoin/blob/master/doc/build-osx.md#deterministic-macos-dmg-notes) about how to create the SDK.

You can copy it into a container with:
```bash
docker cp path/to/MacOSX10.11.sdk.tar.gz container_id:bitcoin/depends/SDKs
```

### Platform Triplets
Common `host-platform-triplets` for cross compilation are:

- `x86_64-w64-mingw32` for Win64
- `x86_64-apple-darwin14` for macOS
- `x86_64-pc-linux-gnu` for generic Linux
- `arm-linux-gnueabihf` for Linux ARM 32 bit
- `aarch64-linux-gnu` for Linux ARM 64 bit
- `riscv64-linux-gnu` for Linux RISC-V 64 bit

You can read more about host target triplets in `autoconf` [here](https://www.gnu.org/software/autoconf/manual/autoconf-2.69/html_node/Specifying-Target-Triplets.html).
