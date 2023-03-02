ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}

ownerMint=0xC4748Fb528Bcf583144225e3F3d0b765B413383A #$(jq -r '.OwnerMint' out/addresses.json)
ticket=0xd9243de6be84EA0f592D20e3E6bd67949D96bfe9

newTicket=$(ETH_FROM=$ETH_FROM seth send $ownerMint \
    'mintTicket(address,address)' $ticket $1 \
    --gas 6000000 --rpc-url $ETH_RPC_URL
)
echo "New ticket minted: $newTicket"