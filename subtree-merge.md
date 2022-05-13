# Upstream Subtree Merge

## How to Verify

If you wanted to verify a merge of the upstream [secp256k1](https://github.com/bitcoin-core/secp256k1) repo into bitcoin/bitcoin.
i.e PR [#22448](https://github.com/bitcoin/bitcoin/pull/22448).

```bash
pushd bitcoin

git fetch upstream pull/22448/head:22448

git checkout 22448

git fetch https://github.com/bitcoin-core/secp256k1
remote: Enumerating objects: 6714, done.
remote: Counting objects: 100% (491/491), done.
remote: Compressing objects: 100% (222/222), done.
remote: Total 6714 (delta 310), reused 371 (delta 268), pack-reused 6223
Receiving objects: 100% (6714/6714), 2.92 MiB | 165.00 KiB/s, done.
Resolving deltas: 100% (4678/4678), done.
From https://github.com/bitcoin-core/secp256k1
 * branch                HEAD       -> FETCH_HEAD

./test/lint/git-subtree-check.sh src/secp256k1
src/secp256k1 in HEAD currently refers to tree b7f4357396a8a5f073bf628567ef10b2e2edd410
src/secp256k1 in HEAD was last updated in commit c020cbaa5c8e9e61b2b8efd8dc09be743fcd4273 (tree b7f4357396a8a5f073bf628567ef10b2e2edd410)
GOOD
```

## Historical Subtree Updates

### [ctaes](https://github.com/bitcoin-core/ctaes)

- https://github.com/bitcoin/bitcoin/pull/9303

### [leveldb](https://github.com/bitcoin-core/leveldb)

- https://github.com/bitcoin/bitcoin/pull/24461
- https://github.com/bitcoin/bitcoin/pull/17398
- https://github.com/bitcoin/bitcoin/pull/15270
- https://github.com/bitcoin/bitcoin/pull/13925
- https://github.com/bitcoin/bitcoin/pull/12451
- https://github.com/bitcoin/bitcoin/pull/2702
- https://github.com/bitcoin/bitcoin/pull/2916

### [minisketch](https://github.com/sipa/minisketch)

- https://github.com/bitcoin/bitcoin/pull/23114

### python-bitcoinrpc (removed)

- https://github.com/bitcoin/bitcoin/pull/6097

### [secp256k1](https://github.com/bitcoin-core/secp256k1)

- https://github.com/bitcoin/bitcoin/pull/24792
- https://github.com/bitcoin/bitcoin/pull/23383
- https://github.com/bitcoin/bitcoin/pull/22448
- https://github.com/bitcoin/bitcoin/pull/20257
- https://github.com/bitcoin/bitcoin/pull/20147
- https://github.com/bitcoin/bitcoin/pull/19944
- https://github.com/bitcoin/bitcoin/pull/19228
- https://github.com/bitcoin/bitcoin/pull/15703
- https://github.com/bitcoin/bitcoin/pull/11421
- https://github.com/bitcoin/bitcoin/pull/8453

### [univalue](https://github.com/bitcoin-core/univalue)

- https://github.com/bitcoin/bitcoin/pull/25113
- https://github.com/bitcoin/bitcoin/pull/22646
- https://github.com/bitcoin/bitcoin/pull/20424
- https://github.com/bitcoin/bitcoin/pull/18099
- https://github.com/bitcoin/bitcoin/pull/17324
- https://github.com/bitcoin/bitcoin/pull/14164
- https://github.com/bitcoin/bitcoin/pull/11952
- https://github.com/bitcoin/bitcoin/pull/11420
- https://github.com/bitcoin/bitcoin/pull/8807
- https://github.com/bitcoin/bitcoin/pull/8863
- https://github.com/bitcoin/bitcoin/pull/6637
