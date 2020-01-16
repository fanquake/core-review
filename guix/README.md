# Guix

[Guix](https://www.gnu.org/software/guix/) is a transactional package manager much like Nix, but unlike Nix, it has more of a focus on [bootstrappability](https://www.gnu.org/software/guix/manual/en/html_node/Bootstrapping.html) and [reproducibility](https://www.gnu.org/software/guix/blog/tags/reproducible-builds/) which are attractive for security-sensitive projects like bitcoin.

If you're interested in downloading a pre-built VM and testing Guix (using QEMU), I have a short guide [here](vm-intro.md).

## Alpine Guix Dockerfile

### Create the alpine-guix image:

```bash
pushd bitcoin
docker build -f ../core-review/guix/Dockerfile \
             -t alpine-guix .
```

You can override where the docker image fetches the guix binary from with `--build-args`.

```bash
pushd bitcoin
docker build -f ../core-review/guix/Dockerfile \
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

Pull the right version of Guix and use it to build:

```bash
guix pull --url=https://github.com/dongcarl/guix.git \
          --branch=2019-05-bitcoin-staging
env PATH="/root/.config/guix/current/bin${PATH:+:}$PATH" ./contrib/guix/guix-build.sh
```

### Build output
```
env PATH="/root/.config/guix/current/bin${PATH:+:}$PATH" guix describe

git rev-parse HEAD

find output/ -type f -print0 | sort -z | xargs -r0 sha256sum
```
