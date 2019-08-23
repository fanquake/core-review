# GitHub Merge Script

[`github-merge.py`](https://github.com/bitcoin-core/bitcoin-maintainer-tools/blob/master/github-merge.py) is the script used for merging PRs into [`bitcoin/bitcoin`](https://github.com/bitcoin/bitcoin).

If you want to run the script and don't have a `git` user configured:

```bash

git clone https://github.com/bitcoin-core/bitcoin-maintainer-tools

pushd bitcoin

git config githubmerge.host https://github.com
git config githubmerge.repository bitcoin/bitcoin

git config user.signingkey 000000
git config user.email "test@example.com"
git config user.name "Test"

../bitcoin-maintainer-tools/github-merge.py 123
```
# Checking out GitHub PRs

Pull requests can also be checked out from GitHub directly using:

```bash
git clone https://github.com/bitcoin/bitcoin

git fetch origin pull/pr_number/head:pr_number

git checkout pr_number
```
