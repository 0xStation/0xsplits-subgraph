# ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}

# factory=0xC259EeF52A74527dcE52f4e9D5C45EaE9d54ebbf

# factory name symbol
createTicket() {
    ticket=$(ETH_FROM=$ETH_FROM seth send $1 \
        'create(string,string)' $2 $3 \
        --gas 6000000 --rpc-url $ETH_RPC_URL
    )
    echo "New ticket deployed at: $ticket" 
}

createTicket $1 $2 $3