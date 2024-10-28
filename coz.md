# Coz: Causal Profiling

Build and install Coz as per: https://github.com/plasma-umass/coz.

#### Insert Progress Points

Add some progress points. For example:

```diff
--- a/src/validation.cpp
+++ b/src/validation.cpp
@@ -5,6 +5,8 @@
 
 #include <validation.h>
 
+#include </usr/include/coz.h>
+
 #include <kernel/coinstats.h>
 #include <kernel/mempool_persist.h>
 
@@ -3881,6 +3883,7 @@ bool Chainstate::AcceptBlock(const std::shared_ptr<const CBlock>& pblock, BlockV
 
 bool ChainstateManager::ProcessNewBlock(const std::shared_ptr<const CBlock>& block, bool force_processing, bool min_pow_checked, bool* new_block)
 {
+    COZ_PROGRESS_NAMED("Enter ProcessNewBlock")
     AssertLockNotHeld(cs_main);
 
     {
@@ -3915,6 +3918,7 @@ bool ChainstateManager::ProcessNewBlock(const std::shared_ptr<const CBlock>& blo
         return error("%s: ActivateBestChain failed (%s)", __func__, state.ToString());
     }
 
+    COZ_PROGRESS_NAMED("Exit ProcessNewBlock")
     return true;
 }
```

#### Compile and Run

Configure for debugging and add `-ldl` to LDFLAGS.

```bash
make -C depends/ NO_QT=1 NO_WALLET=1 NO_UPNP=1 NO_ZMQ=1
./autogen.sh
CONFIG_SITE=/home/ubuntu/bitcoin/depends/x86_64-pc-linux-gnu/share/config.site ./configure --enable-debug LDFLAGS="-ldl"
make -j8

# run
coz run --- src/bitcoind
```

If you see any output like this:
```bash
inspect.cpp:513] Ignoring DWARF format error when reading line table: 
DW_FORM_sec_offset not expected for attribute (DW_AT)0x2137
```
or this:
```bash
terminate called after throwing an instance of 'dwarf::format_error'
  what():  unknown compilation unit version 5
```
it's due to an issue with libelfin and DWARF 4+ (which is used by GCC 9+).
Reconfigure to use DWARF 3 instead:
```bash
CFLAGS="-gdwarf-3" CXXFLAGS="-gdwarf-3"
```

#### Results

Results are dumped into `profile.coz`. 
Take it to https://plasma-umass.org/coz/ to take a look.

