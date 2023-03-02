// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {IPolicy} from "solkit/FungibleToken/Interfaces.sol";

contract AlwaysAllowedTokenPolicy is IPolicy {
    function isAllowed(
        address,
        address,
        address,
        uint256
    ) external pure override returns (bool) {
        return true;
    }
}