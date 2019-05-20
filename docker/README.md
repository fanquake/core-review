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
