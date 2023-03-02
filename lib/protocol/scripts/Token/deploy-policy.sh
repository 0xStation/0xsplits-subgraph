ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}

### Policy

# Options: NeverAllowedTokenPolicy, AlwaysAllowedTokenPolicy, AllowedContractTokenPolicy

# NeverAllowedTokenPolicy=$(ETH_FROM=$ETH_FROM dapp create NeverAllowedTokenPolicy -- --gas 6000000 --rpc-url $ETH_RPC_URL)
# echo "NeverAllowedTokenPolicy deployed at: $NeverAllowedTokenPolicy"

# AlwaysAllowedTokenPolicy=$(ETH_FROM=$ETH_FROM dapp create AlwaysAllowedTokenPolicy -- --gas 6000000 --rpc-url $ETH_RPC_URL)
# echo "AlwaysAllowedTokenPolicy deployed at: $AlwaysAllowedTokenPolicy"

AllowedContractTokenPolicy=$(ETH_FROM=$ETH_FROM dapp create AllowedContractTokenPolicy -- --gas 6000000 --rpc-url $ETH_RPC_URL)
echo "AllowedContractTokenPolicy deployed at: $AllowedContractTokenPolicy"