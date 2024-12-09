# NixOS

https://nixos.org/download.html#nix-install-docker

```bash
docker run --pull=always -it nixos/nix
git clone https://github.com/bitcoin/bitcoin
nix-shell -p binutils boost ccache cmake curl gcc gitMinimal gnumake libevent libsystemtap patch pkg-config python3 sqlite zeromq
```
