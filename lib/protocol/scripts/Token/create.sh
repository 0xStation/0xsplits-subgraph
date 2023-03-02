ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}
# ETH_RPC_URL=http://127.0.0.1:8545

factory=0x59b83f83b8d0C5F08aa9A2b2D69a1cb9bcFD7E88

create() {
    echo $(ETH_FROM=$ETH_FROM seth send $factory \
        'create(string,string)(address)' '"Station Labs Points"' '"RAIL"' \
        --gas 6000000 --rpc-url $ETH_RPC_URL \
    )
        # --keystore ~/.dapp/testnet/8545/keystore \
        # --password /dev/null
    echo "New token deployed at: $token"
}

create