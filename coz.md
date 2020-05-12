# Coz: Causal Profiling

Build and install Coz as per: https://github.com/plasma-umass/coz.

#### Insert Progress Points

Add some progress points. For example:

```diff
diff --git a/src/validation.cpp b/src/validation.cpp
index 8a454c8d1..21274f305 100644
--- a/src/validation.cpp
+++ b/src/validation.cpp
@@ -52,6 +52,8 @@
 #include <boost/algorithm/string/replace.hpp>
 #include <boost/thread.hpp>
 
+#include <path/to/coz.h>
+
 #if defined(NDEBUG)
 # error "Bitcoin cannot be compiled without assertions."
 #endif
@@ -3814,6 +3816,7 @@ bool CChainState::AcceptBlock(const std::shared_ptr<const CBlock>& pblock, Block
 
 bool ProcessNewBlock(const CChainParams& chainparams, const std::shared_ptr<const CBlock> pblock, bool fForceProcessing, bool *fNewBlock)
 {
+       COZ_PROGRESS_NAMED("Enter ProcessNewBlock")
     AssertLockNotHeld(cs_main);
 
     {
@@ -3843,7 +3846,7 @@ bool ProcessNewBlock(const CChainParams& chainparams, const std::shared_ptr<cons
     BlockValidationState state; // Only used to report errors, not invalidity - ignore it
     if (!::ChainstateActive().ActivateBestChain(state, chainparams, pblock))
         return error("%s: ActivateBestChain failed (%s)", __func__, state.ToString());
-
+       COZ_PROGRESS_NAMED("Exit ProcessNewBlock")
     return true;
 }

```

#### Compile and Run

Configure for debugging and add `-ldl` to LDFLAGS.

```bash
make -C depends/ NO_QT=1 NO_WALLET=1 NO_UPNP=1 NO_ZMQ=1
./autogen.sh
./configure --enable-debug --prefix=/home/bitcoin/depends/x86_64-pc-linux-gnu LDFLAGS="-ldl"
make -j8

# run
coz run --- src/bitcoind

# if you see any output like this, and have an empty profile.coz,
# it's due to an issue with libelfin and DWARF 4 (which is used by GCC 9+),
# so reconfigure and use DWARF 3 instead.
inspect.cpp:513] Ignoring DWARF format error when reading line table: 
DW_FORM_sec_offset not expected for attribute (DW_AT)0x2137

CXXFLAGS="-gdwarf-3" CFLAGS="-gdwarf-3"
```

#### Results

Results are dumped into `profile.coz`. 
Take it to https://plasma-umass.org/coz/ to take a look.

