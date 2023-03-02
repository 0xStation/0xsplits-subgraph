// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import { INFTScalar } from "./INFTScalar.sol";
import { Descriptor } from "solkit/Descriptor/Descriptor.sol";
import { NFTMetadata } from "solkit/Metadata/NFTMetadata.sol";
import { ScalarMetadata } from "solkit/Metadata/ScalarMetadata.sol";

contract NFTScalar is INFTScalar, Descriptor, NFTMetadata, ScalarMetadata {
    mapping(uint256 => uint256) internal _values;

    constructor(string memory name_, string memory symbol_, address nft_)
        Descriptor(name_, symbol_) 
        NFTMetadata(nft_) 
    {}

    function valueOf(uint256 tokenId) public view virtual returns (uint256) {
        return _values[tokenId];
    }

    function increaseValue(uint256 tokenId, uint256 amount) public returns (uint256) {
        uint256 oldValue = valueOf(tokenId);

        // switch to SafeMath
        _total += amount;
        _values[tokenId] += amount;
        
        _afterValueUpdate(tokenId, oldValue, valueOf(tokenId));

        emit ValueUpdated(tokenId, oldValue, valueOf(tokenId), int256(amount));
        return valueOf(tokenId);
    }

    function decreaseValue(uint256 tokenId, uint256 amount) public returns (uint256) {
        uint256 oldValue = valueOf(tokenId);
        require(oldValue >= amount, "decrease amount exceeds value");

        // switch to SafeMath
        _total -= amount;
        _values[tokenId] -= amount;

        _afterValueUpdate(tokenId, oldValue, valueOf(tokenId));

        emit ValueUpdated(tokenId, oldValue, valueOf(tokenId), -1 * int256(amount));
        return valueOf(tokenId);
    }

    function _reset(uint256 tokenId, uint256 value) internal {
        _values[tokenId] = value;
    }

    function _afterValueUpdate(uint256 tokenId, uint256 oldValue, uint256 newValue) internal virtual {
    }
}