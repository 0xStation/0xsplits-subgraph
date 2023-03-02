ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}
# ETH_RPC_URL=http://127.0.0.1:8545

WaitingRoom=$(ETH_FROM=$ETH_FROM dapp create WaitingRoom -- --gas 6000000 --rpc-url $ETH_RPC_URL)
echo "Waiting Room deployed at: $WaitingRoom"

# FungibleTokenOwnerModule=$(ETH_FROM=$ETH_FROM dapp create FungibleTokenOwnerModule -- --gas 6000000 --rpc-url $ETH_RPC_URL)
# echo "FungibleToken owner module deployed at: $FungibleTokenOwnerModule"