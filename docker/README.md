# Docker

## General Usage

The dockerfiles in this directory can be used to run `depends` builds for various `HOST`s.
The images will contain all the dependencies required for cross compiling.


For example, to build the Debian image and use it for a build targeting the `RISCV-64` host:

```shell
# Build container
DOCKER_BUILDKIT=1 docker build -f debian.dockerfile -t debian-depends .

# Run with a Bash shell
docker run -it --name debian-depends --workdir /bitcoin debian-depends /bin/bash

# Inside the container
pushd depends

# Build for RISCV-64 bit, skipping Qt packages
make HOST=riscv64-linux-gnu RAPIDCHECK=1 NO_QT=1
popd
./autogen.sh
./configure --prefix=/bitcoin/depends/riscv64-linux-gnu
make check -j6
```

### macOS SDK
Cross compiling for macOS requires the macOSX10.11 SDK. 
There are [notes in the bitcoin/bitcoin repo](https://github.com/bitcoin/bitcoin/blob/master/doc/build-osx.md#deterministic-macos-dmg-notes) about how to create it.

You can copy it into a container with:
```bash
docker cp path/to/MacOSX10.11.sdk.tar.gz container_id:bitcoin/depends/SDKs
```
