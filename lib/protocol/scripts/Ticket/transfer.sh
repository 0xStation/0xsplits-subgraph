ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}

https://eth-rinkeby.alchemyapi.io/v2/ZJIj3ytrFaWioVp550EyzD4MR9q5VClg

ticket=0xd9243de6be84EA0f592D20e3E6bd67949D96bfe9

transfer=$(ETH_FROM=$ETH_FROM seth send $ticket \
    'transferFrom(address,address,uint256)' $1 $2 $3 \
    --gas 6000000 --rpc-url $ETH_RPC_URL
)
echo "Ticket transfered -- id $3 from $1 to $2"