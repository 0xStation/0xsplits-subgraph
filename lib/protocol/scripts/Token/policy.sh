ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}

primitive=0xb3169c0f8849fdAE0f1F5CaFbEF1EA41050080B2
policy=0x830fF6943C49B29fd08eB09A42b9e22716FC94a3

function updateMintPolicy() {
    policy=$(ETH_FROM=$ETH_FROM seth send $primitive \
        'updateMintPolicy(address)' $policy \
        --gas 6000000 --rpc-url $ETH_RPC_URL
    )
    echo "Mint policy updated: $policy" 
}

function updateBurnPolicy() {
    policy=$(ETH_FROM=$ETH_FROM seth send $primitive \
        'updateBurnPolicy(address)' $policy \
        --gas 6000000 --rpc-url $ETH_RPC_URL
    )
    echo "Burn policy updated: $policy" 
}

function updateTransferPolicy() {
    policy=$(ETH_FROM=$ETH_FROM seth send $primitive \
        'updateTransferPolicy(address)' $policy \
        --gas 6000000 --rpc-url $ETH_RPC_URL
    )
    echo "Transfer policy updated: $policy" 
}

updateTransferPolicy
