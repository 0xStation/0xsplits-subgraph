function updateTemplate() {
    updated=$(ETH_FROM=$ETH_FROM seth send $factory \
        'updateTemplate(address)' $1 \
        --gas 6000000 --rpc-url $ETH_RPC_URL
    )
    echo "Template updated: $template" 
}

function template() {
    template=$(seth call $factory \
        "template()(address)" \
        --rpc-url $ETH_RPC_URL )
    echo "template: $template"
}

ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}

factory=0x2c4e2B0e448579501E5d7546B85BB37830209F8f
template=0x108a23bcb07E70850ad96f9Dff3528188EA360e1

updateTemplate $template
template

