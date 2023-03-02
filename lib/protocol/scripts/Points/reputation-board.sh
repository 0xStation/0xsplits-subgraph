ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}

graph=0xa3395B5FEfca8bb39032A9604C0337fF7e847323

totalLocked() {
    TOTAL=$(seth call $graph "totalLocked()(uint256)" --rpc-url $ETH_RPC_URL)
    echo "total staked on graph: $TOTAL"
}

totalStakedOn() {
    tina=$(seth call $graph "totalStakedOn(uint256)(uint256)" 3 --rpc-url $ETH_RPC_URL)
    echo "tina:    $tina"

    mind=$(seth call $graph "totalStakedOn(uint256)(uint256)" 2 --rpc-url $ETH_RPC_URL)
    echo "mind:    $mind"

    conner=$(seth call $graph "totalStakedOn(uint256)(uint256)" 0 --rpc-url $ETH_RPC_URL)
    echo "conner:  $conner"

    brendan=$(seth call $graph "totalStakedOn(uint256)(uint256)" 4 --rpc-url $ETH_RPC_URL)
    echo "brendan: $brendan"

    kristen=$(seth call $graph "totalStakedOn(uint256)(uint256)" 7 --rpc-url $ETH_RPC_URL)
    echo "kristen: $kristen"

    michael=$(seth call $graph "totalStakedOn(uint256)(uint256)" 1 --rpc-url $ETH_RPC_URL)
    echo "michael: $michael"

    calvin=$(seth call $graph "totalStakedOn(uint256)(uint256)" 6 --rpc-url $ETH_RPC_URL)
    echo "calvin:  $calvin"

    darian=$(seth call $graph "totalStakedOn(uint256)(uint256)" 5 --rpc-url $ETH_RPC_URL)
    echo "darian:  $darian"

    akshay=$(seth call $graph "totalStakedOn(uint256)(uint256)" 9 --rpc-url $ETH_RPC_URL)
    echo "akshay:  $akshay"

    kash=$(seth call $graph "totalStakedOn(uint256)(uint256)" 8 --rpc-url $ETH_RPC_URL)
    echo "kash:    $kash"
}

# name
# symbol
# ticket
# token
totalLocked
totalStakedOn $1