ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}

token=0xABf03EDC17De11e80008C3e89919b82AbA34521A
contract=0x20609FDe04cCaDC162A618E2BC667De4a76C7DF0

increaseAllowance() {
    allowance=$(ETH_FROM=$ETH_FROM seth send $token \
        'increaseAllowance(address,uint256)' $contract $1 \
        --gas 6000000 --rpc-url $ETH_RPC_URL
    )
    echo "Increased allowance for contract: $contract $1"
}

increaseAllowance $1