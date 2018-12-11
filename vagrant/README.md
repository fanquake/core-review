### Vagrant

The `Vagrantfile` in this directory contains definitions for multiple different  
operating systems that are useful for testing Bitcoin Core.

For example:
```
vagrant up openbsd64 rsync-auto
```

This provisions an OpenBSD 6.4 box (using openbsd.sh), installs dependencies,  
copies in the core source, configures and compiles binaries and runs tests.

You can connect to the box using:
```
vagrant ssh openbsd64
```
