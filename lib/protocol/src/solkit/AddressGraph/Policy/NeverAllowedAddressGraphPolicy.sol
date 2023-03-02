// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {IPolicy} from "../Interfaces.sol";

contract NeverAllowedAddressGraphPolicy is IPolicy {
    function isAllowed(
        address,
        address,
        address,
        address,
        uint256
    ) external pure override returns (bool) {
        return false;
    }
}