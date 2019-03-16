# Guix

[Guix](https://www.gnu.org/software/guix/) is a transactional package manager much like Nix, but unlike Nix, it has more of a focus on [bootstrappability](https://www.gnu.org/software/guix/manual/en/html_node/Bootstrapping.html) and [reproducibility](https://www.gnu.org/software/guix/blog/tags/reproducible-builds/) which are attractive for security-sensitive projects like bitcoin.

If you're interested in downloading a pre-built VM and testing Guix (using QEMU), I have a short guide [here](vm-intro.md).

## Alpine Guix Dockerfile

### Create the alpine-guix image:

```bash
DOCKER_BUILDKIT=1 docker build -t alpine-guix .
```

### Run the alpine-guix container

Note the use of [__--privileged__](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities) here. Read the documentation before running any image with this flag.

```bash
pushd bitcoin
docker run -it --name alpine-guix --privileged -v $PWD:/bitcoin --workdir /bitcoin alpine-guix
```

### Do a Bitcoin Core build:

```bash
pushd bitcoin
docker exec -it alpine-guix /bin/bash -c "contrib/guix/guix-build.sh"
```
