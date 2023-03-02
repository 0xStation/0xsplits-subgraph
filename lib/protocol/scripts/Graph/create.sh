ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}
# ETH_RPC_URL=http://127.0.0.1:8545

factory=0x518e01435768b19939A28D206042A42e9154EA86

create() {
    # name symbol endorsements points
    graph=$(ETH_FROM=$ETH_FROM seth send $factory \
        'create(string,string,address,address)(address)' '"Station Labs Referrals"' '"RAIL"' $1 $2 \
        --gas 6000000 --rpc-url $ETH_RPC_URL
    )
    echo "New referrals deployed at: $graph"
}

create $1 $2