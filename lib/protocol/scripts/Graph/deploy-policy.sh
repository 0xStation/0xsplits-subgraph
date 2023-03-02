ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}

### Policy

# Options: NeverAllowedAddressGraphPolicy, AlwaysAllowedAddressGraphPolicy, AllowedContractAddressGraphPolicy

# NeverAllowedAddressGraphPolicy=$(ETH_FROM=$ETH_FROM dapp create NeverAllowedAddressGraphPolicy -- --gas 6000000 --rpc-url $ETH_RPC_URL)
# echo "NeverAllowedAddressGraphPolicy deployed at: $NeverAllowedAddressGraphPolicy"

# AlwaysAllowedAddressGraphPolicy=$(ETH_FROM=$ETH_FROM dapp create AlwaysAllowedAddressGraphPolicy -- --gas 6000000 --rpc-url $ETH_RPC_URL)
# echo "AlwaysAllowedAddressGraphPolicy deployed at: $AlwaysAllowedAddressGraphPolicy"

AllowedContractAddressGraphPolicy=$(ETH_FROM=$ETH_FROM dapp create AllowedContractAddressGraphPolicy -- --gas 6000000 --rpc-url $ETH_RPC_URL)
echo "AllowedContractAddressGraphPolicy deployed at: $AllowedContractAddressGraphPolicy"