### Vagrant

The `Vagrantfile` in this directory contains definitions for multiple different operating systems that are useful for testing Bitcoin Core.

It is currently being used with [Virtualbox 6.0](https://www.virtualbox.org/). Compatibility with earlier versions is not guaranteed.

Usage:
```
vagrant up openbsd64 rsync-auto
```

This provisions an OpenBSD 6.4 VM (using [`openbsd.sh`](/vagrant/openbsd.sh)), installs dependencies,  
copies in the core source and configures and compiles binaries.

Connect to the box using:
```
vagrant ssh openbsd64
```

#### Testing Pull Requests:

Use the [github-merge.py](https://github.com/bitcoin/bitcoin/blob/master/contrib/devtools/github-merge.py) script to merge a PR into your local repo:
```
bitcoin/contrib/devtools/github-merge.py 14853
```

Then start/provision a VM.  
In this instance, we'll ssh in and use `gdb` to get a backtrace from a failing unit test:
```
vagrant rsync travis-linux-no-depends-qt
vagrant up travis-linux-no-depends-qt

vagrant ssh travis-linux-no-depends-qt
cd /home/bitcoin
```

Setup gdb:
```
gdb --args src/test/test_bitcoin --log_level=all --run_test=key_properties
GNU gdb (Ubuntu 8.1-0ubuntu3) 8.1.0.20180409-git
... snip ...
Reading symbols from src/test/test_bitcoin...done.
```

Run:
```
(gdb) run
Starting program: /home/bitcoin/src/test/test_bitcoin --log_level=all --run_test=key_properties
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
Running 4 test cases...
Entering test module "Bitcoin Test Suite"
test/key_properties.cpp(22): Entering test suite "key_properties"
test/key_properties.cpp(25): Entering test case "key_uniqueness"
Using configuration: seed=8265346595995684519

Program received signal SIGSEGV, Segmentation fault.
0x000055555622120f in rc::Shrinkable<rc::detail::Any>::value() const ()
```

Obtain a backtrace:
```
(gdb) thread apply all bt
Thread 1 (Thread 0x7ffff7fe3780 (LWP 32251)):
#0  0x000055555622120f in rc::Shrinkable<rc::detail::Any>::value() const ()
#1  0x000055555625d866 in rc::gen::detail::ExecHandler::onGenerate(rc::Gen<rc::detail::Any> const&) ()
#2  0x00005555559b3d7e in rc::Gen<std::tuple<CKey, CKey> >::operator*() const ()
```
