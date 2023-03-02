network=rinkeby # mainnet or rinkeby

ETH_RPC_URL=https://eth-$network.alchemyapi.io/v2/${ALCHEMY_API_KEY}

### Policy

# TicketMintPolicy=$(ETH_FROM=$ETH_FROM dapp create TicketMintPolicy -- --gas 6000000 --rpc-url $ETH_RPC_URL)
# echo "Ticket mint policy deployed at: $TicketMintPolicy"

# TicketBurnPolicy=$(ETH_FROM=$ETH_FROM dapp create TicketBurnPolicy -- --gas 6000000 --rpc-url $ETH_RPC_URL)
# echo "Ticket burn policy deployed at: $TicketBurnPolicy"

# TicketTransferPolicy=$(ETH_FROM=$ETH_FROM dapp create TicketTransferPolicy -- --gas 6000000 --rpc-url $ETH_RPC_URL)
# echo "Ticket transfer policy deployed at: $TicketTransferPolicy"

### Renderer

# FixedRenderer=$(ETH_FROM=$ETH_FROM dapp create FixedRenderer -- --gas 6000000 --rpc-url $ETH_RPC_URL)
# echo "Ticket fixed renderer deployed at: $FixedRenderer"

StationOwnerAddressRenderer=$(ETH_FROM=$ETH_FROM dapp create StationOwnerAddressRenderer -- --gas 6000000 --rpc-url $ETH_RPC_URL)
echo "Station owner address renderer deployed at: $StationOwnerAddressRenderer"

### Module

TicketOwnerModule=$(ETH_FROM=$ETH_FROM dapp create TicketOwnerModule -- --gas 6000000 --rpc-url $ETH_RPC_URL)
echo "Steward module deployed at: $TicketOwnerModule"

### Factory

# ContributorTicketFactory=$(ETH_FROM=$ETH_FROM dapp create ContributorTicketFactory \
#     $TicketMintPolicy $TicketBurnPolicy $TicketTransferPolicy $StationOwnerAddressRenderer $StewardModule \
#     -- --gas 6000000 --rpc-url $ETH_RPC_URL)
# echo "Ticket factory deployed at: $ContributorTicketFactory"

# ContributorTicket=$(ETH_FROM=$ETH_FROM dapp create ContributorTicket \
#     '"Station"' '"RAIL"' \
#     $TicketMintPolicy $TicketBurnPolicy $TicketTransferPolicy $StationOwnerAddressRenderer \
#     -- --gas 6000000 --rpc-url $ETH_RPC_URL)
# echo "Ticket deployed at: $ContributorTicket"