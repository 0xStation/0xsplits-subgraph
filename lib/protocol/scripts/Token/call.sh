network=rinkeby # mainnet or rinkeby

ETH_RPC_URL=https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}

token=0xABf03EDC17De11e80008C3e89919b82AbA34521A

owner() {
    owner=$(seth call $token \
        "owner()(address)" \
        --rpc-url $ETH_RPC_URL )
    echo "owner: $owner"
}

name() {
    name=$(seth call $token \
        "name()(string)" \
        --rpc-url $ETH_RPC_URL )
    echo "name: $name"
}

symbol() {
    symbol=$(seth call $token \
        "symbol()(string)" \
        --rpc-url $ETH_RPC_URL )
    echo "symbol: $symbol"
}

decimals() {
    decimals=$(seth call $token \
        "decimals()(uint8)" \
        --rpc-url $ETH_RPC_URL )
    echo "decimals: $decimals"
}

balanceOf() {
    VALUE=$(seth call $token \
        "balanceOf(address)(uint256)" $1 \
        --rpc-url $ETH_RPC_URL )
    echo "balance of $1: $VALUE"
}

owner
name
symbol
decimals

# echo "Staff: 100"
# balanceOf 0x016562aA41A8697720ce0943F003141f5dEAe006
# balanceOf 0xd32FA3e71737a19eE4CA44334b9f3c52665a6CDB
# balanceOf 0x78918036a8e4B9179bEE3CAB57110A3397986E44
# balanceOf 0xaE55f61f85935BBB68b8809d5c02142e4CbA9a13
# echo "Daily: 50"
# balanceOf 0x65A3870F48B5237f27f674Ec42eA1E017E111D63
# balanceOf 0xB0F0bA31aA582726E36Dc0c79708E9e072455eD2
# balanceOf 0x237c9dbB180C4Fbc7A8DBfd2b70A9aab2518A33f
# balanceOf 0x90A0233A0c27D15ffA23E293EC8dd6f2Ef2942e2
# balanceOf 0x17B7163E708A06De4DdA746266277470dd42C53f
# echo "Weekend: 25"
# balanceOf 0x32447704a3ac5ed491b6091497ffb67a7733b624
# balanceOf 0x69F35Bed06115Dd05AB5452058d9dbe8a7AD80f1
# echo "Visitor: 10"
# balanceOf 0x8FAA5498Ca6fc9A61BA967E07fBc9420aab99E55
# balanceOf 0x2f40e3Fb0e892240E3cd5682D10ce1860275174C

balanceOf 0x7ff6363cd3A4E7f9ece98d78Dd3c862bacE2163d