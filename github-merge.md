# GitHub Merge Script

[`github-merge.py`](https://github.com/bitcoin/bitcoin/blob/master/contrib/devtools/github-merge.py) is a script for merging PRs from [`bitcoin/bitcoin`](https://github.com/bitcoin/bitcoin) into a local repo. 

It can be useful to run the script from somewhere you don't have a `git` user configured and don't want to auth to GitHub (i.e in a Docker container).

```shell

pushd bitcoin

git config githubmerge.host https://github.com
git config githubmerge.repository bitcoin/bitcoin

git config user.signingkey 000000
git config user.email "test@example.com"
git config user.name "Test"

contrib/devtools/github-merge.py 12345
```
# Checking out GitHub PRs

```bash
git clone https://github.com/bitcoin/bitcoin

git fetch origin pull/PR/head:PR-testing

git checkout PR-testing
```
