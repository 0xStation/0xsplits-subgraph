// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {AllowedContract} from "solkit/Mixins/AllowedContract.sol";
import {IPolicy} from "../Interfaces.sol";

contract AllowedContractAddressGraphPolicy is AllowedContract, IPolicy {
    function isAllowed(
        address operator,
        address,
        address,
        address,
        uint256
    ) external view override returns (bool) {
        return isOperatorAllowedContract(operator);
    }
}