// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import { INFTMetadata } from "./INFTMEtadata.sol";
import {IERC721} from "openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTMetadata is INFTMetadata {
    IERC721 internal _nft;

    constructor(address nft_) {
        _nft = IERC721(nft_);
    }

    function nft() public view returns (address) {
        return address(_nft);
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        return _nft.ownerOf(tokenId);
    }
}