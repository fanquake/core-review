### Gitian Building

Bitcoin Core releases are [reproducibly built](https://reproducible-builds.org) using [Gitian Builder](https://github.com/devrandom/gitian-builder).

```bash
brew install coreutils
```
Gitian-builder needs `sha256sum`, which doesn't exist on macOS:
```bash
sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum
```

```bash
brew cask install docker
```
Once Docker is installed, open the .app binary at least once.
This is required so it can request and setup the neccessary permissions.  
You might also want to give Docker access to more CPUs, RAM etc.  
Go to `Preferences -> Advanced` and allocate as required.

### Setup
```bash
mkdir gitian-building
pushd gitian-building
```
Fork and clone a copy of the gitian.sigs repo:
```bash
# After "forking" on GitHub
git clone https://github.com/your_github_username/gitian.sigs.git
```
Clone the other required repositories:
```bash
git clone https://github.com/bitcoin-core/bitcoin-detached-sigs.git
git clone https://github.com/devrandom/gitian-builder.git
git clone https://github.com/bitcoin/bitcoin.git
```

Create the base VMs used for gitian-building:
```bash
pushd gitian-builder
bin/make-base-vm --suite bionic --arch amd64 --docker // For building 0.17 onwards
bin/make-base-vm --suite trusty --arch amd64 --docker // For building 0.15 & 0.16
popd
```


### Fetch Gitian Inputs
```bash
export VERSION=0.18.1
export SIGNER=your_username
export USE_DOCKER=1

pushd gitian.sigs
git checkout -b $SIGNER-$VERSION
popd

pushd bitcoin
git checkout v$VERSION
popd

pushd gitian-builder
make -C ../bitcoin/depends download SOURCES_PATH=`pwd`/cache/common
mkdir -p inputs
wget -P inputs https://bitcoincore.org/cfields/osslsigncode-Backports-to-1.7.1.patch
wget -P inputs https://downloads.sourceforge.net/project/osslsigncode/osslsigncode/osslsigncode-1.7.1.tar.gz
```

If you want to gitian build for macOS, you'll need to get hold of the macOS 10.11 SDK.  
You can read the documentation [here](https://github.com/bitcoin/bitcoin/blob/master/doc/build-osx.md#deterministic-macos-dmg-notes) about how to create it.  
Once you have `MacOSX10.11.sdk.tar.gz`, place it in `gitian-builder/inputs/`.

### Build Unsigned Sigs
Adjust `num-make` and `memory` as needed.
```bash
# Linux
bin/gbuild --num-make 6 --memory 4000 --commit bitcoin=v${VERSION} ../bitcoin/contrib/gitian-descriptors/gitian-linux.yml
bin/gsign --signer "$SIGNER" --release ${VERSION}-linux --destination ../gitian.sigs/ ../bitcoin/contrib/gitian-descriptors/gitian-linux.yml
mv build/out/bitcoin-*.tar.gz build/out/src/bitcoin-*.tar.gz ../

# Windows
bin/gbuild --num-make 6 --memory 4000 --commit bitcoin=v${VERSION} ../bitcoin/contrib/gitian-descriptors/gitian-win.yml
bin/gsign --signer "$SIGNER" --release ${VERSION}-win-unsigned --destination ../gitian.sigs/ ../bitcoin/contrib/gitian-descriptors/gitian-win.yml
mv build/out/bitcoin-*-win-unsigned.tar.gz inputs/bitcoin-win-unsigned.tar.gz
mv build/out/bitcoin-*.zip build/out/bitcoin-*.exe ../

# macOS
bin/gbuild --num-make 6 --memory 4000 --commit bitcoin=v${VERSION} ../bitcoin/contrib/gitian-descriptors/gitian-osx.yml
bin/gsign --signer "$SIGNER" --release ${VERSION}-osx-unsigned --destination ../gitian.sigs/ ../bitcoin/contrib/gitian-descriptors/gitian-osx.yml
mv build/out/bitcoin-*-osx-unsigned.tar.gz inputs/bitcoin-osx-unsigned.tar.gz
mv build/out/bitcoin-*.tar.gz build/out/bitcoin-*.dmg ../
popd
```

### Commit Unsigned Sigs
```bash
pushd gitian.sigs
git add .
git commit -m "$SIGNER $VERSION unsigned sigs"
git push
popd
```

### Build Signed Sigs

Signed signatures can be built once the `detached sigs` are available in the [detached-sigs repo](https://github.com/bitcoin-core/bitcoin-detached-sigs/).

#### macOS:
```bash
pushd gitian-builder
bin/gbuild -i --commit signature=v${VERSION} ../bitcoin/contrib/gitian-descriptors/gitian-osx-signer.yml
bin/gsign --signer "$SIGNER" --release ${VERSION}-osx-signed --destination ../gitian.sigs/ ../bitcoin/contrib/gitian-descriptors/gitian-osx-signer.yml
bin/gverify -v -d ../gitian.sigs/ -r ${VERSION}-osx-signed ../bitcoin/contrib/gitian-descriptors/gitian-osx-signer.yml
mv build/out/bitcoin-osx-signed.dmg ../bitcoin-${VERSION}-osx.dmg
```

#### Windows:
```bash
bin/gbuild -i --commit signature=v${VERSION} ../bitcoin/contrib/gitian-descriptors/gitian-win-signer.yml
bin/gsign --signer "$SIGNER" --release ${VERSION}-win-signed --destination ../gitian.sigs/ ../bitcoin/contrib/gitian-descriptors/gitian-win-signer.yml
bin/gverify -v -d ../gitian.sigs/ -r ${VERSION}-win-signed ../bitcoin/contrib/gitian-descriptors/gitian-win-signer.yml
mv build/out/bitcoin-*win64-setup.exe ../bitcoin-${VERSION}-win64-setup.exe
popd
```

### Commit Signed Sigs
```bash
pushd gitian.sigs
git add .
git commit -m "$SIGNER $VERSION signed sigs"
git push
popd
```

Done 🍻

#### Notes:
Follow build progress using:
```bash
pushd gitian-builder
tail -f var/install.log # Setup
tail -f var/build.log # Building dependencies and Core
```

The first time `depends` is built for a new version, it can take a *long* time, 
as [dependencies](https://github.com/bitcoin/bitcoin/tree/master/depends/packages) are being built for all architectures and operating systems.  
Subsequent builds (0.18.0rc2) will be much faster, as only Bitcoin Core is being compiled.

You can invoke once off builds (useful for testing i.e [#16667](https://github.com/bitcoin/bitcoin/pull/16667)) using something like:
```bash
env USE_DOCKER=1 ./bin/gbuild -j6 -m 6000 \
--commit bitcoin=bd3f5a90ecd6de40516141b23b0861dbba0b31b6 \
--url bitcoin=https://github.com/fanquake/bitcoin.git \
path/to/bitcoin/contrib/gitian-descriptors/gitian-win.yml
```
