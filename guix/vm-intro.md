# Guix VM Image (using QEMU)

```bash
brew install qemu
```

Download the latest `guixsd-vm-image-0.16.0.x86_64-linux.xz` image from https://alpha.gnu.org/gnu/guix/.

Extract
```bash
tar -xJ guixsd-vm-image-0.16.0.x86_64-linux.xz
```

Increase disk size
```bash
qemu-img resize guixsd-vm-image-0.16.0.x86_64-linux +20G
```

Run and login with `root`:
```bash
qemu-system-x86_64 -net user -net nic,model=virtio -m 2048 guixsd-vm-image-0.16.0.x86_64-linux
```

Setup networking
```bash
ifconfig eth0 up
dhclient -v eth0
```

Resize the disk using whichever tool you prefer.

Update GUIX
```bash
guix pull
```

Test installing the `hello` package
```bash
guix package --install hello

guix package --list-installed
```