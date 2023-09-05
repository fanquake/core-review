# Guix

[Guix](https://www.gnu.org/software/guix/) is a transactional package manager much like Nix, but unlike Nix, it has more of a focus on [bootstrappability](https://www.gnu.org/software/guix/manual/en/html_node/Bootstrapping.html) and [reproducibility](https://www.gnu.org/software/guix/blog/tags/reproducible-builds/) which are attractive for security-sensitive projects like bitcoin.

If you're interested in downloading a pre-built VM and testing Guix (using QEMU), I have a short guide [here](vm-intro.md).

## Alpine Guix Dockerfile

### Create the alpine-guix image:

```bash
DOCKER_BUILDKIT=1 docker build --pull --no-cache -t alpine_guix - < Dockerfile
```

You can override where the docker image fetches the guix binary from with `--build-args`.

```bash
pushd bitcoin
docker build -f Dockerfile \
             --build-arg guix_download_path=https://guix.carldong.io \
             --build-arg guix_file_name=guix-binary.x86_64-linux.tar.xz \
             --build-arg guix_checksum=69378399753a74d8f107551430bec3923958f6cdd1cf956851dd6e186adc9605 \
             -t alpine-guix .
```

### Run the alpine-guix container

To `exec` a `guix-daemon` (a prerequisite for guix builds):

```bash
docker run -it --name alpine_guix --privileged alpine_guix
```

The daemon will run in the foreground, so don't be alarmed if it hangs (you may see output like `accepted connection from pid 2828, user root`).

Note the use of `--privileged`. Read the Docker [capabilities documentation](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities) before running any image with this flag.

### Do a Bitcoin Core build:

Exec into the container:

```bash
docker exec -it alpine-guix /bin/bash
```

Default HOSTS:
```bash
x86_64-linux-gnu
arm-linux-gnueabihf
aarch64-linux-gnu
riscv64-linux-gnu
powerpc64-linux-gnu
powerpc64le-linux-gnu
x86_64-w64-mingw32
x86_64-apple-darwin
arm64-apple-darwin
```

Build:

```bash
# Set HOSTS to build for a specific target. i.e
time BASE_CACHE="/base_cache" SOURCE_PATH="/sources" SDK_PATH="/SDKs" HOSTS="x86_64-w64-mingw32" ./contrib/guix/guix-build
```

## Debian Guix Dockerfile

A Debian based Dockerfile is also available, which uses the Debian [Guix package](https://packages.debian.org/trixie/guix).

It can be created using:
```bash
DOCKER_BUILDKIT=1 docker build --pull --no-cache -t debian_guix - < debian.Dockerfile
```

and used the same way as the Alpine container (see above).

## Build output

Providing the following information is useful after a successful build:
```bash
guix describe
uname -m
find guix-build-$(git rev-parse --short=12 HEAD)/output/ -type f -print0 | env LC_ALL=C sort -z | xargs -r0 sha256sum
```

## Bitcoin Core Guix Package

Bitcoin Core is also available via the Guix package manager.

Submitting an update requires [`guix hash`](https://guix.gnu.org/manual/en/html_node/Invoking-guix-hash.html#Invoking-guix-hash) and fixing any build issues. 

Recent Updates:

* [25.0]https://git.savannah.gnu.org/cgit/guix.git/commit/?id=b58fab5982eb45aae2a51c86093e6bbd472d8c9e
* [24.1](https://git.savannah.gnu.org/cgit/guix.git/commit/?id=0aab24855238cc7c7a31066ab39cd94e534b857f)
* [23.1](https://git.savannah.gnu.org/cgit/guix.git/commit/?id=3c8d0f9e71bbddfb5b1f098c713ff37553f0efcc)
* [23.0](https://git.savannah.gnu.org/cgit/guix.git/commit/?id=79e40b6ce8e4f5f499ea338aede75a0810a210c1)
* [0.21.1](https://git.savannah.gnu.org/cgit/guix.git/commit/?id=2fc9d513811e4a737bd7337545732337641d2738)
* [0.21.0](https://git.savannah.gnu.org/cgit/guix.git/commit/?id=d3c8aa3f8214434c8ba819984ed4513796a09e38)
