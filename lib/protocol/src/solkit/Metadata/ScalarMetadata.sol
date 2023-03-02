// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

abstract contract ScalarMetadata {
    uint256 internal _total;

    function decimals() public pure virtual returns (uint8) {
        return 6;
    }

    function total() public view returns (uint256) {
        return _total;
    }
}