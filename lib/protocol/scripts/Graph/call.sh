name() {
    NAME=$(seth call $1 \
        "name()(string)" \
        --rpc-url $ETH_RPC_URL )
    echo "name: $NAME"
}

symbol() {
    SYMBOL=$(seth call $1 \
        "symbol()(string)" \
        --rpc-url $ETH_RPC_URL )
    echo "symbol: $SYMBOL"
}

endorsementsToken() {
    token=$(seth call $1 \
        "endorsementsToken()(address)" \
        --rpc-url $ETH_RPC_URL )
    echo "endorsements: $token"
}

pointsToken() {
    token=$(seth call $1 \
        "pointsToken()(address)" \
        --rpc-url $ETH_RPC_URL )
    echo "points: $token"
}

total() {
    total=$(seth call $1 \
        "total()(uint256)" \
        --rpc-url $ETH_RPC_URL )
    echo "total: $total"
}

balanceOf() {
    # from to
    balance=$(seth call $1 \
        "balanceOf(address,address)(uint256)" $2 $3 \
        --rpc-url $ETH_RPC_URL )
    echo "balance: $balance"
}

ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}

graph=0x3FD059CB7318417a9c8728A9Ab96Cf352515A9B5

name $graph
symbol $graph
endorsementsToken $graph
pointsToken $graph
total $graph
balanceOf $graph $1 $2