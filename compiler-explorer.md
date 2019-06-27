# Compiler Explorer

[Compiler Explorer](https://godbolt.org) is web based tool that can be used to examine and compare assembly output across different compilers (i.e Clang vs GCC) as well as different versions of the same compiler (i.e GCC 6 vs 7).

## GCC Bug 90348
[A bug in GCC](https://gcc.gnu.org/bugzilla/show_bug.cgi?id=90348) `7`, `8` and `9` causes a mis-compilation with the following `C` code:

```c
#include <assert.h>
#include <stdio.h>

void __attribute__ ((noinline)) set_one(unsigned char* ptr)
{
    *ptr = 1;
}

int __attribute__ ((noinline)) check_zero(unsigned char const* in, unsigned int len)
{
    for (unsigned int i = 0; i < len; ++i) {
        if (in[i] != 0) return 0;
    }
    return 1;
}

void set_one_on_stack() {
    unsigned char buf[1];
    set_one(buf);
}

int main() {
    for (int i = 0; i <= 4; ++i) {
        unsigned char in[4];
        for (int j = 0; j < i; ++j) {
            in[j] = 0;
            set_one_on_stack(); // Apparently modifies in[0]
        }
        assert(check_zero(in, i));
    }
}
```

## Bitcoin Core Issue & Fix

This bug was originally reported in [#14580](https://github.com/bitcoin/bitcoin/issues/14580) as a failure when running the `sha256d64` test on a 32-bit distro. It was eventually identified as a bug in GCC.

The [fix applied](https://github.com/bitcoin/bitcoin/pull/15983) to Bitcoin Core involved using [`-fstack-reuse=none`](https://gcc.gnu.org/onlinedocs/gcc/Code-Gen-Options.html) when compiling with GCC.

> This option controls stack space reuse for user declared local/auto variables and compiler generated temporaries.

> reuse_level can be ‘all’, ‘named_vars’, or ‘none’.

> ‘none’ disables stack reuse completely.

## Compiler Explorer Setup

This was a good oppourtunity to use Compiler Explorer to compare the assembly generated with and without the `fstack-reuse` flag.

I took the flags produced by `./configure` inside a [Debian Docker container](docker/debian.dockerfile):
```bash
-Wstack-protector -fstack-protector-all  -Wall -Wextra -Wformat -Wvla -Wredundant-decls  -Wno-unused-parameter -Wno-implicit-fallthrough   -g -O2
```
and setup a Compiler Explorer instance using GCC 9.1 and the `C` code above.

Both compilers used the base configure flags and one had `-fstack-reuse=none` appended.

You can view the setup [here](https://godbolt.org/z/42ZKDS).

Looking at the generated assembly, you can see the difference in output on line 83:

```diff
<   lea rdi, [rsp+3]
---
>   lea rdi, [rsp+4]
```

As mentioned in the original bug report, the issue is seen with GCC 7, 8 and 9.  You can confirm this by changing the version of GCC used by Compiler Explorer. If you use GCC 6 you will not see the issue.