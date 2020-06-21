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

#### Sanitizer special case list

An exclude.txt is provided to be used as [sanitizer special case list](https://clang.llvm.org/docs/SanitizerSpecialCaseList.html). This can be passed to Clang when building bitcoind,
and will instruct the sanitizer, via `-fsanitize-blacklist=exclude.txt"`, to suppress
certain warnings.

#### Build bitcoind
```bash
./autogen.sh
./configure --prefix=/bitcoin/depends/x86_64-pc-linux-gnu \
    --disable-bench \
    --with-sanitizers=memory \
    --with-asm=no \
    --with-utils=no \
    CC=clang \
    CXX=clang++ \
    CFLAGS="${MSAN_FLAGS} -fsanitize-blacklist=/exclude.txt" \
    CXXFLAGS="${MSAN_AND_LIBCXX_FLAGS} -fsanitize-blacklist=/exclude.txt"
make -j6
```