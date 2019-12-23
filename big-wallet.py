#! /usr/bin/env python3

# src/bitcoind -regtest -server
# python3 big-wallet.py ~/Library/Application\ Support/Bitcoin/ tx_count

import argparse
import os
import random
import sys
import time

auth = os.getenv('AUTHPROXY', '../bitcoin/test/functional/test_framework')
sys.path.append(auth)
from authproxy import AuthServiceProxy

parser = argparse.ArgumentParser()
parser.add_argument('datadir')
parser.add_argument('txcount', type=int)
args = parser.parse_args()

# Wait for cookie file to be created
while not os.path.exists(args.datadir + '/regtest/.cookie'):
    time.sleep(0.5)

# Read .cookie file to get user and pass
with open(args.datadir + '/regtest/.cookie') as f:
    userpass = f.readline().lstrip().rstrip()
rpc = AuthServiceProxy('http://{}@127.0.0.1:18443'.format(userpass))

# Wait for bitcoind to be ready
ready: bool = False
while not ready:
    try:
        rpc.getblockchaininfo()
        ready = True
    except Exception:
        time.sleep(0.5)
        pass
print('bitcoind ready')

for item in rpc.listwalletdir()['wallets']:
    if 'big' == item['name']:
        break;
else:
    rpc.createwallet('big')

if 'big' not in rpc.listwallets():
    rpc.loadwallet('big')

def_rpc = AuthServiceProxy('http://{}@127.0.0.1:18443/wallet/'.format(userpass))
big_rpc = AuthServiceProxy('http://{}@127.0.0.1:18443/wallet/big'.format(userpass))

print('mining')
gen_addr = big_rpc.getnewaddress()
if rpc.getblockcount() == 0:
    big_rpc.generatetoaddress(200, gen_addr)

self_addr = big_rpc.getnewaddress()
send_addr = def_rpc.getnewaddress()

while big_rpc.getwalletinfo()['txcount'] < args.txcount:
    for i in range(0, 1000):
        if i % 100 == 0:
            print(i)
        big_rpc.generatetoaddress(1, gen_addr)
        for j in range(0, 10):

            if big_rpc.getbalance() < 500:
                print("rebalancing")
                def_rpc.sendtoaddress(big_rpc.getnewaddress(), def_rpc.getbalance(), "", "", True)
                big_rpc.generatetoaddress(6, gen_addr)

            amt = round(random.randint(10000, 500 * 100000000) / 100000000, 8)
            addr = random.choice([send_addr, self_addr])
            big_rpc.sendtoaddress(addr, amt)
