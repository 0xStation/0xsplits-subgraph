// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {ContractOwner} from "solkit/Mixins/ContractOwner.sol";
import {INFTScalar} from "solkit/Primitive/INFTScalar.sol";

contract PointsOwnerModule is ContractOwner {
    function increasePoints(address points, uint256 tokenId, uint256 amount) external onlyOwnerOf(points) {
        INFTScalar(points).increaseValue(tokenId, amount);   
    }

    function decreasePoints(address points, uint256 tokenId, uint256 amount) external onlyOwnerOf(points) {
        INFTScalar(points).increaseValue(tokenId, amount);   
    }
}