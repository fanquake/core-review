# Docker

Fedora 29
```
DOCKER_BUILDKIT=1 docker build -f path/to/fedora.dockerfile -t fedora-depends .

docker run -it --name fedora-depends --workdir /bitcoin fedora-depends
pushd depends
make -j6 RAPIDCHECK=1
popd
./autogen.sh && ./configure --prefix=/bitcoin/depends/x86_64-pc-linux-gnu
make check -j6
```
