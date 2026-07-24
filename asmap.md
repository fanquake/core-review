# ASMap

https://github.com/bitcoin-core/asmap-data

```bash
git clone https://github.com/asmap/kartograf
podman build --tag kartograf .

# sub in the -w= param with the collab launch time
podman run -it --name kartograf_run kartograf map -w=1823008000 -irr -rv -s
```