# OSS Fuzz

https://github.com/google/oss-fuzz/tree/master/projects/bitcoin-core

```bash
git clone https://github.com/google/oss-fuzz/

python3 infra/helper.py build_image bitcoin-core

python3 infra/helper.py build_fuzzers --engine libfuzzer \
									  --sanitizer address \
									  --architecture aarch64
									  bitcoin-core
```
