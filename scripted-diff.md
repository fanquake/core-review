# Scripted Diff

```bash
sed -i -e "s/something/different thing/" src/some_file.cpp
```


```bash
scripted-diff: use std::memset() over memset()

-BEGIN VERIFY SCRIPT-

sed -i -e "s/ memset(/ std::memset(/" $(git grep -l "memset(" -- ":(exclude)src/bench/nanobench.h" ":(exclude)src/secp256k1")

-END VERIFY SCRIPT-
```