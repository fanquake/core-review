# Podman

## General Usage

The imagefiles in this directory can be used to run `depends` builds for various `HOST`s.

For example, to build the Debian image and use it for a build targeting the `RISCV-64` host:

```bash
# Build container
podman build --pull --no-cache -t debian_depends - < debian.imagefile

# Run with a Bash shell
podman run -it debian_depends

# Inside the container: build depends for RISCV-64 bit, skipping Qt packages
make HOST=riscv64-linux-gnu NO_QT=1 -C depends/
cmake -B build --toolchain /bitcoin/depends/riscv64-linux-gnu/toolchain.cmake
cmake --build build
```

### macOS SDK
Cross compiling for macOS requires the macOS SDK.
There are [notes in the bitcoin/bitcoin repo](https://github.com/bitcoin/bitcoin/tree/master/contrib/macdeploy#sdk-extraction) about how to create it.

You can copy it into a container with:
```bash
podman cp path/to/Xcode-15.0-15A240d-extracted-SDK-with-libcxx-headers.tar.gz <container_name>:bitcoin/depends/SDKs
```

### Platform Triplets
Common `host-platform-triplets` for cross compilation are:

- `x86_64-w64-mingw32` for Win64
- `x86_64-apple-darwin` for x86_64 macOS
- `arm64-apple-darwin` for arm64 macOS
- `i686-pc-linux-gnu` for Linux 32 bit
- `x86_64-pc-linux-gnu` for Linux 64 bit
- `arm-linux-gnueabihf` for Linux ARM 32 bit
- `aarch64-linux-gnu` for Linux ARM 64 bit
- `riscv32-linux-gnu` for Linux RISC-V 32 bit
- `riscv64-linux-gnu` for Linux RISC-V 64 bit
- `powerpc64-linux-gnu` for Linux POWER 64-bit
- `powerpc64le-linux-gnu` for Linux POWER 64-bit (little endian)
- `s390x-linux-gnu` for Linux S390X

You can read more about host target triplets [here](https://www.gnu.org/software/autoconf/manual/html_node/Specifying-Target-Triplets.html).
