ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}

ticket=0xd9243de6be84EA0f592D20e3E6bd67949D96bfe9
renderer=0xcD44cA93CA7d395ecd3703b8667B522C70375Fa9

updateRenderer() {
    echo $(ETH_FROM=$ETH_FROM seth send $ticket \
        'updateRenderer(address)' $1 \
        --gas 6000000 --rpc-url $ETH_RPC_URL
    )
    echo "New renderer updated"
}

updateBaseURI() {
    uri=$(ETH_FROM=$ETH_FROM seth send $renderer \
        'updateBaseURI(string)' $1 \
        --gas 6000000 --rpc-url $ETH_RPC_URL
    )
    echo "Base uri updated: $uri"
}

callBaseURI() {
    uri=$(ETH_FROM=$ETH_FROM seth call $renderer \
        'baseURI()(string)' \
        --gas 6000000 --rpc-url $ETH_RPC_URL
    )
    echo "Base uri: $uri"
}

callTokenURIOf() {
    uri=$(ETH_FROM=$ETH_FROM seth call $renderer \
        'tokenURIOf(address,uint256)(string)' $ticket $1 \
        --gas 6000000 --rpc-url $ETH_RPC_URL
    )
    echo "Base uri: $uri"
}

testString() {
    uri=$(ETH_FROM=$ETH_FROM seth call $renderer \
        'testString()(string)' \
        --gas 6000000 --rpc-url $ETH_RPC_URL
    )
    echo "Test0 uri: $uri"
}

testMultiString() {
    uri=$(ETH_FROM=$ETH_FROM seth call $renderer \
        'testMultiString()(string)' \
        --gas 6000000 --rpc-url $ETH_RPC_URL
    )
    echo "Test1 uri: $uri"
}


testAddressToString() {
    uri=$(ETH_FROM=$ETH_FROM seth call $renderer \
        'testAddressToString(address)(string)' $ticket \
        --gas 6000000 --rpc-url $ETH_RPC_URL
    )
    echo "Test2 uri: $uri"
}

updateRenderer $renderer
# updateBaseURI $1
# callBaseURI
# callTokenURIOf $1
