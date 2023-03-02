ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}

### Primitive

Points=$(ETH_FROM=$ETH_FROM dapp create Points \
    -- --gas 6000000 --rpc-url $ETH_RPC_URL)
echo "Points primitive template deployed at: $Points"

### Factory

# template [modules] mintPolicy burnPolicy transferPolicy
PointsCloneFactory=$(ETH_FROM=$ETH_FROM dapp create PointsCloneFactory \
    $Points [0x20609FDe04cCaDC162A618E2BC667De4a76C7DF0] 0xbC622ED29901B910aF46dBfd8C7c6D9503eDf0a7 0x7F6C827F723eC3eeC5967696f1cF851f8417c9E3 0x7F6C827F723eC3eeC5967696f1cF851f8417c9E3 \
    -- --gas 6000000 --rpc-url $ETH_RPC_URL)
echo "Points factory deployed at: $PointsCloneFactory"