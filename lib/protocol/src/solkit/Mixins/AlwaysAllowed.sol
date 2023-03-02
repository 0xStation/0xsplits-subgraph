// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

abstract contract AlwaysAllowed {
    function alwaysAllowed() public pure returns (bool) {
        return true;
    }
}