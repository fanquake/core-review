# Upstream Subtree Merge

## How to Verify

If you wanted to verify a merge of the upstream [secp256k1](https://github.com/bitcoin-core/secp256k1) repo into bitcoin/bitcoin. i.e PR [#15703](https://github.com/bitcoin/bitcoin/pull/15703).

```bash
pushd bitcoin
./contrib/devtools/github-merge.py 15703
[pull/15703/local-merge 12f00cb7a] Merge #15703: Update secp256k1 subtree to latest upstream
 Date: Mon Apr 1 09:09:24 2019 +0800
#15703 Update secp256k1 subtree to latest upstream into master
* 99df276da Update the secp256k1 subtree to the latest upstream version (Pieter Wuille) (pull/15703/head)
* 54245985f Squashed 'src/secp256k1/' changes from 0b70241850..b19c000063 (Pieter Wuille)

Dropping you on a shell so you can try building/testing the merged source.
Run 'git diff HEAD~' to show the changes being merged.
Type 'exit' when done.

git fetch https://github.com/bitcoin-core/secp256k1
warning: no common commits
remote: Enumerating objects: 10, done.
remote: Counting objects: 100% (10/10), done.
remote: Compressing objects: 100% (9/9), done.
remote: Total 4513 (delta 2), reused 6 (delta 1), pack-reused 4503
Receiving objects: 100% (4513/4513), 1.84 MiB | 335.00 KiB/s, done.
Resolving deltas: 100% (3157/3157), done.
From https://github.com/bitcoin-core/secp256k1
 * branch                HEAD       -> FETCH_HEAD

./test/lint/git-subtree-check.sh src/secp256k1
src/secp256k1 in HEAD currently refers to tree e862ca412860538b4969e6f77c8c005695e5ed28
src/secp256k1 in HEAD was last updated in commit 54245985fb3c89d72e285c4db39d38ed2f5fb0de (tree e862ca412860538b4969e6f77c8c005695e5ed28)
src/secp256k1 in HEAD was last updated to upstream commit b19c000063be11018b4d1a6b0a85871ab9d0bdcf (tree e862ca412860538b4969e6f77c8c005695e5ed28)
GOOD
```

## Historical Subtree Updates

### [ctaes](https://github.com/bitcoin-core/ctaes)

- https://github.com/bitcoin/bitcoin/pull/9303

### [leveldb](https://github.com/bitcoin-core/leveldb)

- https://github.com/bitcoin/bitcoin/pull/15270
- https://github.com/bitcoin/bitcoin/pull/13925
- https://github.com/bitcoin/bitcoin/pull/12451
- https://github.com/bitcoin/bitcoin/pull/2702
- https://github.com/bitcoin/bitcoin/pull/2916

### python-bitcoinrpc (removed)
- https://github.com/bitcoin/bitcoin/pull/6097

### [secp256k1](https://github.com/bitcoin-core/secp256k1)

- https://github.com/bitcoin/bitcoin/pull/15703
- https://github.com/bitcoin/bitcoin/pull/11421
- https://github.com/bitcoin/bitcoin/pull/8453

### [univalue](https://github.com/bitcoin-core/univalue)

- https://github.com/bitcoin/bitcoin/pull/14164
- https://github.com/bitcoin/bitcoin/pull/11952
- https://github.com/bitcoin/bitcoin/pull/11420
- https://github.com/bitcoin/bitcoin/pull/8807
- https://github.com/bitcoin/bitcoin/pull/8863
- https://github.com/bitcoin/bitcoin/pull/6637
