# Flame Graphs

Notes on producing [Flame Graphs](https://github.com/brendangregg/FlameGraph) for Bitcoin Core.

This is based off [some work](https://github.com/eklitzke/bitcoin/blob/flamegraphs/doc/flamegraphs.md) originally done by [Evan Klitzke](https://github.com/eklitzke).

### Colouring 
This directory includes a patch that will colour the graphs such that:
* Yellow - Bitcoin Core
* Blue - Boost
* Green - LevelDB
* Orange - System
* Red - Everything else


### Generating
```bash
# clone the Flame Graph repo
git clone https://github.com/brendangregg/FlameGraph && cd FlameGraph

# apply the bitcoin colouring patch
patch -p1 < path/to/core-review/flamegraph/bitcoin-colour.patch

# run bitcoind
./bitcoind

# capture 180s worth of data
sample bitcoind 180 -wait -f sample.output

cat sample.output | ./stackcollapse-sample.awk | ./flamegraph.pl --color bitcoin > sample.svg

firefox --new-window "file://$(realpath sample.svg)"
```

You can also filter the stack output before creating the graph:

```bash
cat sample.output | ./stackcollapse-sample.awk | \
grep -i 'ProcessMessage' | \
./flamegraph.pl --color bitcoin > sample.svg
```

You should end up with graphs that look similar too this:

![Flame Graph](flamegraph.png)
