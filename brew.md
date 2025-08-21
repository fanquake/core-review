# Homebrew

```bash
docker pull docker.io/homebrew/brew:latest
docker run -it homebrew/brew

brew install bitcoin --head --debug # ignore the 2 patch failures
brew test bitcoin
```