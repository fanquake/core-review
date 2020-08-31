# .tbd stubs

.tbd (Text-based Dynamic Library) stubs are a new representation for dynamic
libraries and frameworks and are now used in Apples SDKs. The files are YAML,
thus are human readable and editable.

The TAPI (Text-based Application Programming Interface) library/project comprises
of tooling to create, edit and package .tbd stubs as well as the dynamic library
used by ld to support linking using the stubs.

The [apple-libtapi](https://github.com/tpoechtrager/apple-libtapi) project comprises 
of a (slightly modified) copy of Apples open source [tapi library](https://opensource.apple.com/tarballs/tapi/) as well as the LLVM (Clang) source required to build it.

This project is one component of the Bitcoin Core macOS build toolchain (along
with Clang, ld64 etc).

# tapi & .tbd demo with libbitcoinconsensus (YMMV)

Compile libconsensus, with reduced exports. 
This currently means building [#19522](https://github.com/bitcoin/bitcoin/pull/19522).

```bash
./autogen.sh
./configure --disable-tests --disable-bench --with-utils=no \
            --with-daemon=no --with-gui=no --disable-wallet \
            --with-libs=yes --enable-reduce-exports
make -j8
```

Now use `tapi` to generate a .tbd stub from the libbitcoinconsensus.dylib
```bash
xcrun tapi stubify src/.libs/libbitcoinconsensus.0.dylib
# what's inside?
cat src/.libs/libbitcoinconsensus.0.tbd
```

```yaml
--- !tapi-tbd-v3
archs:           [ x86_64 ]
uuids:           [ 'x86_64: FD431C9E-AF1F-365D-BAB6-F2C3B92921AE' ]
platform:        macosx
flags:           [ not_app_extension_safe ]
install-name:    '/usr/local/lib/libbitcoinconsensus.0.dylib'
exports:         
  - archs:           [ x86_64 ]
    symbols:         [ _bitcoinconsensus_verify_script, _bitcoinconsensus_verify_script_with_amount, 
                       _bitcoinconsensus_version, _secp256k1_context_clone, _secp256k1_context_create, 
                       _secp256k1_context_destroy, _secp256k1_context_no_precomp, 
                       _secp256k1_context_preallocated_clone, _secp256k1_context_preallocated_clone_size, 
                       _secp256k1_context_preallocated_create, _secp256k1_context_preallocated_destroy, 
                       _secp256k1_context_preallocated_size, _secp256k1_context_randomize, 
                       _secp256k1_context_set_error_callback, _secp256k1_context_set_illegal_callback, 
                       _secp256k1_ec_privkey_negate, _secp256k1_ec_privkey_tweak_add, 
                       _secp256k1_ec_privkey_tweak_mul, _secp256k1_ec_pubkey_combine, 
                       _secp256k1_ec_pubkey_create, _secp256k1_ec_pubkey_negate, 
                       _secp256k1_ec_pubkey_parse, _secp256k1_ec_pubkey_serialize, 
                       _secp256k1_ec_pubkey_tweak_add, _secp256k1_ec_pubkey_tweak_mul, 
                       _secp256k1_ec_seckey_negate, _secp256k1_ec_seckey_tweak_add, 
                       _secp256k1_ec_seckey_tweak_mul, _secp256k1_ec_seckey_verify, 
                       _secp256k1_ecdsa_recover, _secp256k1_ecdsa_recoverable_signature_convert, 
                       _secp256k1_ecdsa_recoverable_signature_parse_compact, _secp256k1_ecdsa_recoverable_signature_serialize_compact, 
                       _secp256k1_ecdsa_sign, _secp256k1_ecdsa_sign_recoverable, 
                       _secp256k1_ecdsa_signature_normalize, _secp256k1_ecdsa_signature_parse_compact, 
                       _secp256k1_ecdsa_signature_parse_der, _secp256k1_ecdsa_signature_serialize_compact, 
                       _secp256k1_ecdsa_signature_serialize_der, _secp256k1_ecdsa_verify, 
                       _secp256k1_nonce_function_default, _secp256k1_nonce_function_rfc6979, 
                       _secp256k1_scratch_space_create, _secp256k1_scratch_space_destroy ]
    weak-def-symbols: [ __ZTINSt3__115basic_stringbufIcNS_11char_traitsIcEENS_9allocatorIcEEEE, 
                        __ZTINSt3__118basic_stringstreamIcNS_11char_traitsIcEENS_9allocatorIcEEEE, 
                        __ZTINSt3__119basic_istringstreamIcNS_11char_traitsIcEENS_9allocatorIcEEEE, 
                        __ZTINSt3__119basic_ostringstreamIcNS_11char_traitsIcEENS_9allocatorIcEEEE, 
                        __ZTSNSt3__115basic_stringbufIcNS_11char_traitsIcEENS_9allocatorIcEEEE, 
                        __ZTSNSt3__118basic_stringstreamIcNS_11char_traitsIcEENS_9allocatorIcEEEE, 
                        __ZTSNSt3__119basic_istringstreamIcNS_11char_traitsIcEENS_9allocatorIcEEEE, 
                        __ZTSNSt3__119basic_ostringstreamIcNS_11char_traitsIcEENS_9allocatorIcEEEE ]
...
```

Now we want to write a program to test linking against our .tbd stub. 
First we should copy it and the header into `/usr/local`:
```bash
cp src/.libs/libbitcoinconsensus.0.tbd /usr/local/lib/libbitcoinconsensus.tbd
cp src/script/bitcoinconsensus.h /usr/local/include
```

Some c++ that utilizes one of the many libbitcoinconsensus APIs:
```cpp
#include <bitcoinconsensus.h>
#include <iostream>

int main() {
    std::cout << "Libconsensus API Version: " << bitcoinconsensus_version() << "\n";
    return 0;
}
```

Compile and link:
```bash
clang++ consensus.cpp -lbitcoinconsensus -v -o consensus
```

Run:
```bash
./consensus
...
dyld: Library not loaded: /usr/local/lib/libbitcoinconsensus.0.dylib
  Referenced from: /path/to/your/binary/./consensus
  Reason: image not found
[1]    45811 abort      ./consensus
```

😲

As expected, the binary wont actually run, because we haven't installed the
libbitcoinconsensus dylib. The tbd stubs are enough to link against at buildtime,
but at run time, you still need the actual dynamic library.

```bash
cp src/.libs/libbitcoinconsensus.0.dylib /usr/local/lib
```

Re-run:
```bash
./consensus
Libconsensus API Version: 1
```

If there is a .tbd and a .dylib present in `/usr/local/lib` the .tbd seems to
take precedence. You can test this by modifying the stub to remove the symbol we
are using `_bitcoinconsensus_version`. When you try and recompile, linking will fail:
```bash
Undefined symbols for architecture x86_64:
  "_bitcoinconsensus_version", referenced from:
      _main in consensus-67628f.o
ld: symbol(s) not found for architecture x86_64
```

If you then delete the .tbd stub entirely, and try and recompile, it will succed,
as it's now linking directly against the .dylib.

# Diffing libtapi against upstream

## Apple LLVM Project (Clang)

```bash
git clone https://github.com/apple/llvm-project
git clone https://github.com/tpoechtrager/apple-libtapi

cd llvm-project
git checkout 729748d085a90bd2a4af36efbfb2dc33b4704de3

rm -rf clang/test
rm -rf clang/unittests/
rm -rf clang/www
cd ..

# compare clang
diffoscope --exclude-directory-metadata=yes llvm-project/clang apple-libtapi/src/llvm/projects/clang/
```

## libtapi tarball

```
wget https://opensource.apple.com/tarballs/tapi/tapi-1100.0.11.tar.gz
tar xf tapi-1100.0.11.tar.gz
cd tapi-1100.0.11.tar.gz
rm -rf test/
rm -rf unittests/
cd ..

# compare libtapi
diffoscope --exclude-directory-metadata=yes tapi-1100.0.11 apple-libtapi/src/libtapi
```

Example diff is available [here](https://gist.github.com/fanquake/1512109cc69d0a61f352e326f34bb90a).

## -allowable_client ld

One of the modifications to the libtapi tarball is the removal of the `-allowable_client ld`
link flag.

`man ld`

> -allowable_client name
> 
> Restricts what can link against the dynamic library being created.  By default
> any code can link against any dylib. But if a dylib is supposed to be private
> to a small set of clients, you can formalize that by adding a `-allowable_client`
> for each client.

This seems to work as advertised, resulting in an inability to link against a .dylib
usless you are building a binary (or anything?) with an allowed name. i.e

`private_lib.cpp`
```cpp
int func_in_priv_lib(int a) {
  return a * 2;
}
```

`private_lib.h`
```cpp
int func_in_priv_lib(int);
```

`bin.cpp`
```cpp
#include <private_lib.h>

#include <iostream>

int main() {
  std::cout << func_in_priv_lib(4) << "\n";
  return 0;
}
```

Build libprivate with `-allowable_client ld`:
```bash
clang++ private_lib.cpp -Wl,-dylib -o libprivate.dylib -Wl,-allowable_client,ld
```

Note the addition of a `LC_SUB_CLIENT` load command:
```bash
Load command 11
          cmd LC_SUB_CLIENT
      cmdsize 16
       client ld (offset 12)
```

Try and link to libprivate when building `bin.cpp`:
```bash
clang++ bin.cpp -I/path/to/dir -L/path/to/dir -o bin -lprivate
ld: cannot link directly with dylib/framework, your binary is not an allowed client of /Users/michael/Desktop/allowable_client/libprivate.dylib for architecture x86_64
clang: error: linker command failed with exit code 1 (use -v to see invocation)
```

Build but name the output `ld`:
```bash
clang++ bin.cpp -I/path/to/dir -L/path/to/dir -o ld -lprivate
./ld
8
```

You can acheive the same result using `-client_name,ld`:
```bash
clang++ bin.cpp -I/path/to/dir -L/path/to/dir -o ld -lprivate -Wl,-client_name,ld
./bin
8
```
