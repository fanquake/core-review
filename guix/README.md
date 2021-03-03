# Guix

[Guix](https://www.gnu.org/software/guix/) is a transactional package manager much like Nix, but unlike Nix, it has more of a focus on [bootstrappability](https://www.gnu.org/software/guix/manual/en/html_node/Bootstrapping.html) and [reproducibility](https://www.gnu.org/software/guix/blog/tags/reproducible-builds/) which are attractive for security-sensitive projects like bitcoin.

If you're interested in downloading a pre-built VM and testing Guix (using QEMU), I have a short guide [here](vm-intro.md).

## Alpine Guix Dockerfile

### Create the alpine-guix image:

```bash
docker build -f Dockerfile -t alpine-guix .
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
docker run -it --name alpine-guix --privileged alpine-guix
```

The daemon will run in the foreground, so don't be alarmed if it hangs (you may see output like `accepted connection from pid 2828, user root`).

Note the use of `--privileged`. Read the Docker [capabilities documentation](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities) before running any image with this flag.

### Do a Bitcoin Core build:

Exec into the container:

```bash
docker exec -it alpine-guix /bin/bash
```

Update Guix:
```bash
guix pull # supply --max-jobs=X to use more cores

# you may need to set GUIX_PROFILE afterwards
GUIX_PROFILE="/root/.config/guix/current"
. "$GUIX_PROFILE/etc/profile"
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
x86_64-apple-darwin18
```

Build:

```bash
# Set HOSTS to build for a specific target
# i.e
HOSTS="x86_64-w64-mingw32" ./contrib/guix/guix-build.sh
```

## Debian Guix Dockerfile

A Debian based Dockerfile is also available, which uses the Debian [Guix package](https://packages.debian.org/bullseye/guix).

It can be created using:
```bash
docker build -f debian.Dockerfile -t debian-guix .
```

and run / used the same way as the Alpine container (see above).

## Build output

Providing the following information is useful after a successful build:
```bash
guix describe

git rev-parse HEAD

find output/ -type f -print0 | env LC_ALL=C sort -z | xargs -r0 sha256sum
```

## Bitcoin Core Guix Package

Bitcoin Core is also available via the Guix package manager.

Submitting an update requires [`guix hash`](https://guix.gnu.org/manual/en/html_node/Invoking-guix-hash.html#Invoking-guix-hash) and fixing any build issues. 

Recent Updates:

* [0.20.1](https://git.savannah.gnu.org/cgit/guix.git/commit/?id=fa268b28e1ccc392c85846810d836034c96df3c0)
* [0.19.1](https://git.savannah.gnu.org/cgit/guix.git/commit/?id=90799c35bd9cadaf7c28be5ea6e41ec692d5b4a4)
* [0.19.0.1](https://git.savannah.gnu.org/cgit/guix.git/commit/?id=4730878b81a84e54408917c17f4b80e354423d61)
* [0.18.1](https://git.savannah.gnu.org/cgit/guix.git/commit/?id=1219a7cc0521e4916287acd265e50b0af2bfb336)
* [0.18.0](https://git.savannah.gnu.org/cgit/guix.git/commit/?id=bcfc54fff80ef6a11fc53c61db333a8065bbfeef)
* [0.17.1](https://git.savannah.gnu.org/cgit/guix.git/commit/?id=0a59cc6e8590fc6c2c56dc35aca5c4b558d67901)
* [0.16.1](https://git.savannah.gnu.org/cgit/guix.git/commit/?id=6f88285ab1b3a3df8fe8247db5fd92801ec477cf)
* [0.15.1](https://git.savannah.gnu.org/cgit/guix.git/commit/?id=0632c6a84d61c85e9e75a84b345853f52252f234)
