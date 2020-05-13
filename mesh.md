# Mesh

Mesh is a replacement for `maclloc` that trys to recover from memory fragmentation.

This video is worth watching: https://www.youtube.com/watch?v=c1UBJbfR-H0.

Install it following the instructions in the README: https://github.com/plasma-umass/Mesh. 

You may also need to install [`libtinfo5`](https://packages.debian.org/buster/libtinfo5).

Compile `bitcoind` as usual.

Preload `libmesh.so` and set `MALLOCSTATS=1` when running:

```bash
MALLOCSTATS=1 LD_PRELOAD=libmesh.so src/bitcoind
....
2020-05-13T00:12:48.988675Z [shutoff] Shutdown: done
MESH COUNT:         46440
Meshed MB (total):  181.4
Meshed pages HWM:   32434
Meshed MB HWM:      126.7
MH Alloc Count:     379875
MH Free  Count:     663645
MH High Water Mark: 152451
```