# NixOS

https://nixos.org/download.html#nix-install-docker

```bash
docker run --pull=always -it nixos/nix
git clone https://github.com/bitcoin/bitcoin
nix-shell -p gitMinimal binutils boost cmake curl gcc gnumake libevent patch pkg-config python3 sqlite
```
