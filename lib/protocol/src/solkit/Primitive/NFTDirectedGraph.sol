// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {Descriptor} from "solkit/Descriptor/Descriptor.sol";
import {NFTMetadata} from "solkit/Metadata/NFTMetadata.sol";
import {ScalarMetadata} from "solkit/Metadata/ScalarMetadata.sol";

contract NFTDirectedGraph is Descriptor, NFTMetadata, ScalarMetadata {
    mapping(uint256 => mapping(uint256 => uint256)) internal _edges;

    constructor(string memory name_, string memory symbol_, address nft_) 
        Descriptor(name_, symbol_)
        NFTMetadata(nft_) 
    {}

    function edgeOf(uint256 from, uint256 to) public view returns (uint256) {
        return _edges[from][to];
    }

    function _increase(uint256 from, uint256 to, uint256 amount) internal {
        _total += amount;
        _edges[from][to] += amount;
    }

    function _decrease(uint256 from, uint256 to, uint256 amount) internal {
        require(edgeOf(from, to) >= amount, "amount greater than current edge value");
        _total -= amount;
        _edges[from][to] -= amount;
    }
}