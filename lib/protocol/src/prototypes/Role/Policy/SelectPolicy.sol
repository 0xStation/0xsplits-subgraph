// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {IOptionPolicy} from "../Role.sol";
import {AllowedModule} from "solkit/Mixins/AllowedModule.sol";

contract RoleSelectPolicy is AllowedModule, IOptionPolicy {
    function isAllowed(
        address operator,
        uint256,
        uint256
    ) external view returns (bool) {
        return isAllowedModule(operator);
    }
}