#!/bin/bash

for((i=1;i<=10000000;i++));

do
    ore --rpc ${PRC}  --keypair ~/.config/solana/id.json --priority-fee ${PRIORITY_FEE} mine --threads ${THREADS}
done
