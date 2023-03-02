ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}

primitive=0xb3169c0f8849fdAE0f1F5CaFbEF1EA41050080B2
policy=0x830fF6943C49B29fd08eB09A42b9e22716FC94a3
module=0xa2d65d0DC3F4Fe5F1083fc51029Fe9F17e6ceA68

function updateModule() {
    updated=$(ETH_FROM=$ETH_FROM seth send $policy \
        'updateModule(address,address,bool)' $primitive $module $1 \
        --gas 6000000 --rpc-url $ETH_RPC_URL
    )
    echo "Module updated" 
}

function callAllowedModules() {
    allowed=$(seth call $policy \
        "allowedModules(address,address)(bool)" $primitive $module \
        --rpc-url $ETH_RPC_URL )
    echo "allowed: $allowed"
}

# updateModule 1
callAllowedModules