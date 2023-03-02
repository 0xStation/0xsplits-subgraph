network=rinkeby # mainnet or rinkeby

ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}

points=0xe3431a20922D6A4f31926425E997FF398B6E75D6

name() {
    name=$(seth call $points \
        "name()(string)" \
        --rpc-url $ETH_RPC_URL )
    echo "name: $name"
}

symbol() {
    symbol=$(seth call $points \
        "symbol()(string)" \
        --rpc-url $ETH_RPC_URL )
    echo "symbol: $symbol"
}

decimals() {
    decimals=$(seth call $points \
        "decimals()(uint8)" \
        --rpc-url $ETH_RPC_URL )
    echo "decimals: $decimals"
}

value() {
    value=$(seth call $points \
        "value(uint256)(uint256)" $1 \
        --rpc-url $ETH_RPC_URL )
    echo "value: $value"
}

name
symbol
decimals

# echo "Staff"

# echo "Daily Commuters"

# echo "Weekend Commuters"

# echo "Visitors"
value $1
