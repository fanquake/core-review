# MSAN - https://clang.llvm.org/docs/MemorySanitizer.html

Build and run the MSAN Docker image. It builds on the [base image](/docker/base.dockerfile).

```bash
# don't use --pull as base should be local
DOCKER_BUILDKIT=1 docker build --no-cache -f msan.dockerfile -t msan .

docker run -it msan /bin/bash
```

#### Build depends
```bash
make -C depends/ NO_WALLET=1 NO_QT=1 NO_ZMQ=1 NO_NATPMP=1 NO_UPNP=1 \
    CC=clang CXX=clang++ \
    CFLAGS="${MSAN_FLAGS}" \
    CXXFLAGS="${MSAN_AND_LIBCXX_FLAGS}"
```

#### Sanitizer special case list

An exclude.txt is provided to be used as [sanitizer special case list](https://clang.llvm.org/docs/SanitizerSpecialCaseList.html). 
This can be passed to Clang when building bitcoind, and will instruct the sanitizer,
via `-fsanitize-blacklist=exclude.txt"`, to suppress certain warnings.

#### Build bitcoind
```bash
./autogen.sh
CONFIG_SITE=/bitcoin/depends/aarch64-unknown-linux-gnu/share/config.site ./configure \
    --with-sanitizers=memory \
    --with-asm=no \
    --enable-suppress-external-warnings \
    CFLAGS="${MSAN_FLAGS} -fsanitize-blacklist=/exclude.txt" \
    CXXFLAGS="${MSAN_AND_LIBCXX_FLAGS} -fsanitize-blacklist=/exclude.txt"
make
```