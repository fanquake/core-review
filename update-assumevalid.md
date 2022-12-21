# Reviewing assumevalid updates

`assumevalid` was introduced in [#9484](https://github.com/bitcoin/bitcoin/pull/9484) (Bitcoin Core [0.14.0](https://bitcoincore.org/en/releases/0.14.0/)). 

A good summary of IBD, the history of checkpointing and the rational behind `assumevalid` is available [here](https://bitcoincore.org/en/2017/03/08/release-0.14.0/#ibd).

## Validating Updates
Validating updates is simply running RPC commands, and verifying that the output from your node matches the values being proposed in the pull request. 

For example, if you were reviewing [#15429](https://github.com/bitcoin/bitcoin/pull/15429):

Run `bitcoin-cli getchaintxstats` with a block window of `4096`, and the blockhash of the new assumevalid block.

From the output, check that the following values match those in the PR:

- `time` -> nTime
- `txcount` -> nTxCount
- `txrate` -> dTxRate

```bash
bitcoin-cli getchaintxstats 4096 0000000000000000000f1c54590ee18d15ec70e68c8cd4cfbadb1b4f11697eee

{
  "time": 1550374134, 👍
  "txcount": 383732546, 👍
  "window_final_block_hash": "0000000000000000000f1c54590ee18d15ec70e68c8cd4cfbadb1b4f11697eee",
  "window_block_count": 4096,
  "window_tx_count": 8872107,
  "window_interval": 2407303,
  "txrate": 3.685496590998308 👍
}
```

Run `bitcoin-cli getblockheader` passing the blockhash of the new assumevalid block.

From the output, check that the following values match those in the PR:

- `chainwork` -> consensus.nMinimumChainWork
- `hash` -> consensus.defaultAssumeValid
- `height` -> consensus.defaultAssumeValid comment

```bash
bitcoin-cli getblockheader 0000000000000000000f1c54590ee18d15ec70e68c8cd4cfbadb1b4f11697eee

{
  "hash": "0000000000000000000f1c54590ee18d15ec70e68c8cd4cfbadb1b4f11697eee", 👍
  "confirmations": 3892,
  "strippedsize": 115156,
  "size": 131899,
  "weight": 477367,
  "height": 563378, 👍
  "version": 536870912,
  "versionHex": "20000000",
  "merkleroot": "3c9b9295588dbab8388785dd9f70c9d7f42948632556298c8453aad755e30822",
  # not displaying tx data
  "time": 1550374134,
  "mediantime": 1550373349,
  "nonce": 3355453177,
  "bits": "172e6f88",
  "difficulty": 6061518831027.271,
  "chainwork": "0000000000000000000000000000000000000000051dc8b82f450202ecb3d471", 👍
  "nTx": 359,
  "previousblockhash": "00000000000000000001827a07f51769246d852e63c413bc2cd5caa104970f3f",
  "nextblockhash": "0000000000000000001d6cf3d8d1bf2e0b1883f6684bb2dddcb57a5d4c81ec7f"

```

### Previous assumevalid updates (block height)
 - [751565](https://github.com/bitcoin/bitcoin/pull/25946)
 - [724466](https://github.com/bitcoin/bitcoin/pull/24418)
 - [691719](https://github.com/bitcoin/bitcoin/pull/22499)
 - [654683](https://github.com/bitcoin/bitcoin/pull/20263)
 - [623950](https://github.com/bitcoin/bitcoin/pull/18500)
 - [597379](https://github.com/bitcoin/bitcoin/pull/17002)
 - [563378](https://github.com/bitcoin/bitcoin/pull/15429)
 - [534292](https://github.com/bitcoin/bitcoin/pull/13794)
 - [506067](https://github.com/bitcoin/bitcoin/pull/12269)
 - [477890](https://github.com/bitcoin/bitcoin/pull/10945)
 - [447235](https://github.com/bitcoin/bitcoin/pull/9484) (Introduction)
