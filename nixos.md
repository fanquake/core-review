# NixOS

https://nixos.org/download.html#nix-install-docker

```bash
docker run --pull=always -it nixos/nix
nix-shell -p gitMinimal autoconf automake binutils curl gcc gnumake hexdump libtool patch pkg-config python3
git clone https://github.com/bitcoin/bitcoin
```