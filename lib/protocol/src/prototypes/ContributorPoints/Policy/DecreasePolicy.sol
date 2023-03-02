// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract DecreasePolicy {
    function isAllowed(address, uint256, uint256, uint256) external pure returns (bool) {
        return false;
    }
}