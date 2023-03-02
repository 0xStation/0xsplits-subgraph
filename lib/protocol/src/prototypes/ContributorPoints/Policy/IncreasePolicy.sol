// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {AllowedModule} from "solkit/Mixins/AllowedModule.sol";

contract IncreasePolicy is AllowedModule {
    function isAllowed(address operator, uint256, uint256, uint256) external view returns (bool) {
        return isAllowedModule(operator);
    }
}