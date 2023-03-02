ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}

primitive=0x09B29bcb130E4A642f270AF3F6bDf2480D065835
contract=0x488d547e5C383d66815c67fB1356A3F35d3885CF
contract2=0x3FD059CB7318417a9c8728A9Ab96Cf352515A9B5

factory=0x8FF16Ae63EeFc86826AF3a08940C357f44EfCe33
contracts=[0x8e4340065Ed2E4Bd7B11fc545FfE1744aA8A1A45,0x74090bfb9b2F83a8B692756406c7bc585dA7043e]

function updateContract() {
    updated=$(ETH_FROM=$ETH_FROM seth send $primitive \
        'updateContract(address,bool)' $1 $2 \
        --gas 6000000 --rpc-url $ETH_RPC_URL
    )
    echo "Allowed contract updated: $1 set to $2" 
}

function isAllowedContract() {
    allowed=$(seth call $primitive \
        "isAllowedContract(address)(bool)" $1 \
        --rpc-url $ETH_RPC_URL )
    echo "allowed: $allowed"
}

function swapContracts() {
    updated=$(ETH_FROM=$ETH_FROM seth send $primitive \
        'swapContracts(address[],address[])' [$contract] [$contract2] \
        --gas 6000000 --rpc-url $ETH_RPC_URL
    )
    echo "Contracts swapped: $contract set to false, $contract2 set to true" 
}

function updateAllowedContracts() {
    updated=$(ETH_FROM=$ETH_FROM seth send $factory \
        'updateAllowedContracts(address[])' $contracts \
        --gas 6000000 --rpc-url $ETH_RPC_URL
    )
    echo "Allowed contracts updated: $contracts" 
}

function allowedContracts() {
    allowed=$(seth call $factory \
        "allowedContracts()(address[])" \
        --rpc-url $ETH_RPC_URL )
    echo "allowed: $allowed"
}

updateContract $contract 1
# swapContracts
isAllowedContract $contract
# isAllowedContract $contract2

# updateAllowedContracts
# allowedContracts