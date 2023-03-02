network=rinkeby # mainnet or rinkeby

ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}
# ETH_RPC_URL=http://127.0.0.1:8545

waitingRoom=0x20609FDe04cCaDC162A618E2BC667De4a76C7DF0
graph=0x488d547e5C383d66815c67fB1356A3F35d3885CF

endorse() {
    # recipient amount initiative
    graph=$(ETH_FROM=$ETH_FROM seth send $waitingRoom \
        'endorse(address,address,uint256,uint256)' $graph $1 $2 $3 \
        --gas 6000000 --rpc-url $ETH_RPC_URL
    )
    echo "Waiting room endorsement: $graph"
}

endorse $1 $2 $3