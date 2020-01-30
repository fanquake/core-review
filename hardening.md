# Hardening

Bitcoin Core makes use of many hardening features. Some of them are documented here.

## Linux

### RELRO `-z,relro`

There are sections in a binary that may need to be writable by the loader, but don't
need to be writable by the application during runtime. Passing `-z,relro` to the
linker instructs it to mark any applicable sections as such, and the loader will
mark them read-only at runtime, before giving control back to the application.

```bash
readelf -l -W src/bitcoind
...
Program Headers:
  Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
  <other-headers...>
  GNU_RELRO      0x55adf0 0x000000000055bdf0 0x000000000055bdf0 0x00d210 0x00d210 R   0x1
```

### Bind Now `-z,now`

It's common for binaries to use lazy symbol binding to improve startup times.
This means that references to functions in dynamic libraries are resolved when
they are first used, instead of at startup. Passing `-z,now` to the linker will
make it mark the binary such that the dynamic loader will resolve all function
references at startup. See also `RTLD_NOW`in the [`dlopen` man page](https://linux.die.net/man/3/dlopen).

```bash
readelf -d src/bitcoind
...

Dynamic section at offset 0x5670e0 contains 31 entries:
  Tag        Type                         Name/Value
 <other entries>
 0x000000000000001e (FLAGS)              BIND_NOW
 0x000000006ffffffb (FLAGS_1)            Flags: NOW PIE
```

When combined with RELRO, this allows the loader to mark more of the binary
as read-only.

### Non-executable Stack

A non-executable stack is now standard for most modern toolchains. If you want
an executable stack you will likely have to op-in by passing `-z,execstack` to
the linker. Bitcoin Core is built with a non-executable stack, you can check this
by looking for the `RW` flags in the `GNU_STACK` program header.

```bash
readelf -l -W src/bitcoind
...
Program Headers:
  Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
  <other-headers...>
  GNU_STACK      0x000000 0x0000000000000000 0x0000000000000000 0x000000 0x000000 RW  0x10
```

If you modify configure.ac to pass `Wl,-z,execstack` to the linker, you'll find:

```bash
Program Headers:
  Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
  <other-headers...>
  GNU_STACK      0x000000 0x0000000000000000 0x0000000000000000 0x000000 0x000000 RWE 0x10
```

Further Reading:
* [NX bit](https://en.wikipedia.org/wiki/NX_bit).
* The Ubuntu Security Team is working to [eliminate executable stacks](https://wiki.ubuntu.com/SecurityTeam/Roadmap/ExecutableStacks).
* Gentoo Linux notes on [GNU Stack management](https://wiki.gentoo.org/wiki/Hardened/GNU_stack_quickstart).

## Windows

#### Terminate on Heap Corruption

If the Windows heap manager detects an error in any heap used by the process it
will terminate it.

Enabled in [#17916](https://github.com/bitcoin/bitcoin/pull/17916).

#### [Data Execution Prevention](https://docs.microsoft.com/en-us/windows/win32/memory/data-execution-prevention)

Data Execution Prevention (DEP) is enabled by default for all 64-bit Windows
processes. We used to set this explicity via a call to [SetProcessDEPPolicy()](https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-setprocessdeppolicy),
however we no-longer support 32-bit on Windows, and the call will always fail
when made from a 64-bit process.

## macOS

### bind_at_load

This is the macOS/ld64 equivalent of `-z,now`. From man `ld`:

> Sets a bit in the mach header of the resulting binary which tells `dyld`
to bind all symbols when the binary is loaded, rather than lazily.


#### TODO

PIE, PIC, Stack Smashing Protector
