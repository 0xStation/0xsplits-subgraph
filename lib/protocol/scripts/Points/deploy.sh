network=rinkeby # mainnet or rinkeby

ETH_RPC_URL=https://eth-$network.alchemyapi.io/v2/${ALCHEMY_API_KEY}

### Policy

# IncreasePolicy=$(ETH_FROM=$ETH_FROM dapp create IncreasePolicy -- --gas 6000000 --rpc-url $ETH_RPC_URL)
# echo "Increase policy deployed at: $IncreasePolicy"

# DecreasePolicy=$(ETH_FROM=$ETH_FROM dapp create DecreasePolicy -- --gas 6000000 --rpc-url $ETH_RPC_URL)
# echo "Decrease policy deployed at: $DecreasePolicy"

### Module

PointsOwnerModule=$(ETH_FROM=$ETH_FROM dapp create PointsOwnerModule -- --gas 6000000 --rpc-url $ETH_RPC_URL)
echo "Steward module deployed at: $PointsOwnerModule"

### Factory

# increasePolicy decreasePolicy stewardModule
PointsFactory=$(ETH_FROM=$ETH_FROM dapp create PointsFactory \
    0xD45526Db86530e1fa54E79bd5c4140F4B0AbD667 0x35Dc4fE4c4ac720031e107a77F01A7De4789E6EB 0x8e1a4dd2F6Fa1FA3b0F8C381f9a5C6c78b252FD7 \
    -- --gas 6000000 --rpc-url $ETH_RPC_URL)
echo "Points factory deployed at: $PointsFactory"