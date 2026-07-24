# Guix Graph

https://guix.gnu.org/manual/1.5.0/en/html_node/Invoking-guix-graph.html

```bash
git clone https://github.com/bitcoin/bitcoin/

# TYPE is one of: package, reverse-package, bag, bag-emerged,
#                 bag-with-origins, reverse-bag   (default: package)
#
# BACKEND: graphviz, d3js, cypher, cyclonedx-json (default: graphviz)

guix repl -- core_graph.scm --host=HOST [--type=TYPE] [--backend=BACKEND]

# PDF Graph
guix repl -- core_graph.scm --host=x86_64-linux-gnu
dot -Tpdf manifest_x86_64-linux-gnu_package.dot -o manifest.pdf

# JSON dump
guix repl -- core_graph.scm --host=arm64-apple-darwin --backend=cyclonedx-json

grep llvm -C2 manifest_arm64-apple-darwin_package_cyclonedx-json.json
    {
      "type": "application",
      "name": "llvm",
      "version": "19.1.7"
    },
```

### Package paths

```bash
guix graph --path python-lief python
python-lief@1.0.0
ninja@1.13.2
python-wrapper@3.12.12
python@3.12.12
```