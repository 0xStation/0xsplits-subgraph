ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}

stewardModule=0x8e1a4dd2F6Fa1FA3b0F8C381f9a5C6c78b252FD7
points=0xe3431a20922D6A4f31926425E997FF398B6E75D6

increaseValue() {
    value=$(ETH_FROM=$ETH_FROM seth send $stewardModule \
        'increaseValue(address,uint256,uint256)' $points $1 $2 \
        --gas 6000000 --rpc-url $ETH_RPC_URL
    )
    echo "Points value increased: $points $1 $2"
}


echo "CMT: 1200e6"
increaseValue 0 1200000000
increaseValue 2 1200000000
increaseValue 3 1200000000
echo "KC: 600e6"
increaseValue 7 600000000
increaseValue 6 600000000
echo "M: 400e6"
increaseValue 1 400000000
echo "B: 300e6"
increaseValue 4 300000000
echo "A: 200e6"
increaseValue 12 200000000
echo "KA: 100e6"
increaseValue 10 100000000
increaseValue 11 100000000
echo "NAA: 50e6"
increaseValue 13 50000000
increaseValue 14 50000000
increaseValue 9 50000000