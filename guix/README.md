# Guix

[Guix](https://www.gnu.org/software/guix/) is a transactional package manager much like Nix, but unlike Nix, it has more of a focus on [bootstrappability](https://www.gnu.org/software/guix/manual/en/html_node/Bootstrapping.html) and [reproducibility](https://www.gnu.org/software/guix/blog/tags/reproducible-builds/) which are attractive for security-sensitive projects like bitcoin.

If you're interested in downloading a pre-built VM and testing Guix (using QEMU), I have a short guide [here](vm-intro.md).

## Alpine Guix Dockerfile

### Create the alpine-guix image:

Guix building is a WIP and requires the changes in [#15277](https://github.com/bitcoin/bitcoin/pull/15277). Merge them into your local repo before building the image.

```bash
pushd bitcoin
DOCKER_BUILDKIT=1 docker build -f ../core-review/guix/Dockerfile -t alpine-guix .
```

### Run the alpine-guix container

To `exec` a `guix-daemon` (a prerequisite for guix builds):

```bash
docker run -it --name alpine-guix --privileged --workdir /bitcoin alpine-guix
```

The daemon will run in the foreground, so don't be alarmed if it hangs (you may see output like `accepted connection from pid 2828, user root`).

Note the use of `--privileged`. Read the Docker [capabilities documentation](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities) before running any image with this flag.

### Do a Bitcoin Core build:

```bash
docker exec -it alpine-guix /bin/bash -c "contrib/guix/guix-build.sh"
```

If you have issues with packages not being available, similar to:

```shell
guix environment: error: gcc: package not found for version 8.3.0
guix environment: error: failed to load 'contrib/guix/manifest.scm':
gnu/packages.scm:540:4: In procedure specification->package+output:
Throw to key `quit' with args `(1)'.
```

you might need to run `guix pull` before running the build script. i.e:

```shell
guix pull && export PATH="/root/.config/guix/current/bin${PATH:+:}$PATH" && contrib/guix/guix-build.sh
```
