// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {LockableSettings} from "./LockableSettings.sol";

abstract contract AllowedModule is LockableSettings {
    mapping(address => mapping(address => bool)) public allowedModules;

    event ModuleUpdated(address primitive, address module, bool allowed);

    function updateModule(
        address primitive,
        address module,
        bool allowed
    ) external settingsUnlocked(primitive) onlyOwnerOf(primitive) {
        allowedModules[primitive][module] = allowed;
        emit ModuleUpdated(primitive, module, allowed);
    }

    function isAllowedModule(address module) internal view returns (bool) {
        return allowedModules[msg.sender][module];
    }
}