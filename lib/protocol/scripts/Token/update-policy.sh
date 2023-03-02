ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}

token=0x8A7799932a4caae4309Cf491a3081bb587162311

updateMintPolicy() {
    policy=$(ETH_FROM=$ETH_FROM seth send $token \
        'updateIssuePolicy(address)' $1 \
        --gas 6000000 --rpc-url $ETH_RPC_URL
    )
    echo "Policy updated for token: $token"
}

updateMintPolicy $1