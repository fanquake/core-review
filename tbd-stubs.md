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
