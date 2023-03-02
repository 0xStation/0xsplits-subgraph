// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {Ownable} from "openzeppelin/contracts/access/Ownable.sol";

import {Descriptor} from "solkit/Descriptor/Descriptor.sol";
import {NFTMetadata} from "solkit/Metadata/NFTMetadata.sol";
import {INFTOption} from "./INFTOption.sol";

contract NFTOption is Ownable, NFTMetadata, Descriptor, INFTOption {
    // tokenId => optionId
    mapping(uint256 => uint256) internal _selections;
    // optionId => number of tokenIds with option
    mapping(uint256 => uint256) internal _selectionCounts;

    constructor(string memory name_, string memory symbol_, address nft_) 
        Descriptor(name_, symbol_) 
        NFTMetadata(nft_)
    {}

    function selectionOf(uint256 tokenId) public view returns (uint256) {
        return _selections[tokenId];
    }

    function selectionCount(uint256 optionId) public view returns (uint256) {
        return _selectionCounts[optionId];
    }

    function optionURI(uint256 optionId) external view virtual returns (string memory) {}

    function select(uint256 tokenId, uint256 optionId) public returns (uint256) {
        uint256 prevSelection = selectionOf(tokenId);
        require(optionId != prevSelection, "option updates must change state");

        _beforeOptionSelect(tokenId, optionId);
        
        if (prevSelection != 0) {
            // decrease count of previously selected option
            _selectionCounts[prevSelection] -= 1;
        }
        if (optionId != 0) {
            // increase count of selected option
            _selectionCounts[optionId] += 1;
        }

        _selections[tokenId] = optionId;
        emit Select(tokenId, optionId);
        _afterOptionSelect(tokenId, optionId);
        return optionId;
    }

    function _beforeOptionSelect(uint256 tokenId, uint256 optionId) internal virtual {}

    function _afterOptionSelect(uint256 tokenId, uint256 optionId) internal virtual {}
}