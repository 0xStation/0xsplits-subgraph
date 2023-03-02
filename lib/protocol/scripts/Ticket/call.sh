ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}

ticket=0xd9243de6be84EA0f592D20e3E6bd67949D96bfe9

name() {
    NAME=$(seth call --rpc-url $ETH_RPC_URL $ticket "name()(string)")
    echo "name: $NAME"
}

symbol() {
    SYMBOL=$(seth call --rpc-url $ETH_RPC_URL $ticket "symbol()(string)")
    echo "symbol: $SYMBOL"
}

ownerOf() {
    OWNER=$(seth call --rpc-url $ETH_RPC_URL $ticket "ownerOf(uint256)(address)" $1)
    echo "owner of $1: $OWNER"
}

tokenURI() {
    VALUE=$(seth call --rpc-url $ETH_RPC_URL $ticket "tokenURI(uint256)(string)" $1)
    echo "token uri of $1: $VALUE"
}

# name
# symbol
# ownerOf $1
tokenURI $1
