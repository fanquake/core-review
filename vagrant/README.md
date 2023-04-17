### Vagrant

The `Vagrantfile` in this directory contains definitions for multiple different operating systems that are useful for testing Bitcoin Core.

It is currently being used with [Virtualbox 7.0](https://www.virtualbox.org/). Compatibility with earlier versions is not guaranteed.

## Usage:

```shell
vagrant up openbsd --provider virtualbox
```

This provisions a OpenBSD VM (using [`openbsd.sh`](/vagrant/openbsd.sh)) and installs dependencies.

You can then connect to the box using:
```shell
vagrant ssh openbsd
```
