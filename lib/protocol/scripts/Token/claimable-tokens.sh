ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}

issuer=0xeaf58B4450E331d2D4A0c73ECCE5D5A5E8E7c77B
graph=0xa3395B5FEfca8bb39032A9604C0337fF7e847323

claimableTokens() {
    CLAIMABLE=$(seth call $issuer "claimableTokens(address,uint256)(uint256)" $graph $1 --rpc-url $ETH_RPC_URL)
    echo "claimable tokens: $CLAIMABLE"
}

claimableTokens $1