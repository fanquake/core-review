### Vagrant

The `Vagrantfile` in this directory contains definitions for multiple different operating systems that are useful for testing Bitcoin Core.

It is currently being used with [Virtualbox 6.0](https://www.virtualbox.org/). Compatibility with earlier versions is not guaranteed.

## Usage:

If you wanted to test Pull Request [#15968](https://github.com/bitcoin/bitcoin/pull/15968):

```shell
PR=15968 vagrant up openbsd65
```

This provisions a OpenBSD VM (using [`openbsd.sh`](/vagrant/openbsd.sh)), installs build dependencies and sets up some useful env vars. It also checks out the `#15968` branch and compiles `BerkeleyDB`.

You can then connect to the box using:
```shell
vagrant ssh openbsd65
```
