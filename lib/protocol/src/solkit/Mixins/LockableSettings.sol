// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {ContractOwner} from "./ContractOwner.sol";

abstract contract LockableSettings is ContractOwner {
    mapping(address => bool) public settingsLocked;

    event SettingsLocked(address indexed token);

    modifier settingsUnlocked(address token) {
        require(
            !settingsLocked[token],
            "LockableSettings: settings locked"
        );
        _;
    }

    function lockSettings(address token) public settingsUnlocked(token) onlyOwnerOf(token) {
        settingsLocked[token] = true;
        emit SettingsLocked(token);
    }
}