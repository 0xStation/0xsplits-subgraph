network=rinkeby # mainnet or rinkeby

ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}

factory=0x8C310865F4A2997AB764d79296C4872B57a55f5c
# name symbol nft
points=$(ETH_FROM=$ETH_FROM seth send $factory \
    'create(string,string,address)(address)' $1 $2 $3 \
    --gas 6000000 --rpc-url $ETH_RPC_URL
)
echo "New points deployed at: $points"