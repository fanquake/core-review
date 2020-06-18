# MSAN - https://clang.llvm.org/docs/MemorySanitizer.html

Build and run the MSAN Docker image. It builds on the [base image](/docker/base.dockerfile).

```bash
# don't use --pull as base should be local
DOCKER_BUILDKIT=1 docker build --no-cache -f msan.dockerfile -t msan .

docker run -it msan /bin/bash
```

#### Build depends
```bash
make -C depends/ NO_WALLET=1 NO_QT=1 CC=clang CXX=clang++ \
    CFLAGS="${MSAN_FLAGS}" \
    CXXFLAGS="${MSAN_AND_LIBCXX_FLAGS}" \
    boost_cxxflags="-std=c++11 -fvisibility=hidden -fPIC ${MSAN_AND_LIBCXX_FLAGS}" \
    zeromq_cxxflags="-std=c++11 ${MSAN_AND_LIBCXX_FLAGS}"
```

#### Apply patches

By design, MSAN does not have a way to suppress false positives. In some cases this means code must be modified to supress warnings.

This patch has been taken from https://github.com/bitcoin/bitcoin/pull/18288.

```bash
git apply -v /random.patch
```

#### Build bitcoind
```bash
./autogen.sh
./configure --prefix=/bitcoin/depends/x86_64-pc-linux-gnu \
    -with-sanitizers=memory \
    --with-asm=no \
    CC=clang \
    CXX=clang++ \
    CFLAGS="${MSAN_FLAGS}" \
    CXXFLAGS="${MSAN_AND_LIBCXX_FLAGS}"
```