network=rinkeby # mainnet or rinkeby

ETH_RPC_URL=https://eth-$network.alchemyapi.io/v2/${ALCHEMY_API_KEY}

### Policy

### Module

RoleOwnerModule=$(ETH_FROM=$ETH_FROM dapp create RoleOwnerModule -- --gas 6000000 --rpc-url $ETH_RPC_URL)
echo "Steward module deployed at: $RoleOwnerModule"

### Factory