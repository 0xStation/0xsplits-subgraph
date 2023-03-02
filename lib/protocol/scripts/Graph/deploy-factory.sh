ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}
# ETH_RPC_URL=http://127.0.0.1:8545

### Primitive

Referrals=$(ETH_FROM=$ETH_FROM dapp create Referrals \
    -- --gas 6000000 --rpc-url $ETH_RPC_URL)
echo "Referrals primitive template deployed at: $Referrals"

### Factory

# template [modules] mintPolicy
ReferralsCloneFactory=$(ETH_FROM=$ETH_FROM dapp create ReferralsCloneFactory \
    $Referrals [0x20609FDe04cCaDC162A618E2BC667De4a76C7DF0] 0x0BC670eAABa7128cbF091C08A698bf400E083d1E \
    -- --gas 6000000 --rpc-url $ETH_RPC_URL)
echo "Referrals factory deployed at: $ReferralsCloneFactory"