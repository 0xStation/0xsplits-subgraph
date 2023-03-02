// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {Ownable} from "openzeppelin/contracts/access/Ownable.sol";

import {Role} from "./Role.sol";
import {AllowedModule} from "solkit/Mixins/AllowedModule.sol";

contract RoleFactory is Ownable {
    address public selectPolicy;
    address public stewardModule;
    
    event RoleCreated(address indexed token, address indexed role, string name, string symbol);

    constructor(
        address selectolicy_,
        address stewardModule_
    ) {
        selectPolicy = selectolicy_;
        stewardModule = stewardModule_;
    }

    function updateSelectPolicy(address implementation) public onlyOwner {
        selectPolicy = implementation;
    }

    function create(
        string calldata name,
        string calldata symbol,
        address token
    ) external returns (address) {
        Role role = new Role(
            name, 
            symbol,
            token,
            selectPolicy
        );

        AllowedModule(selectPolicy).updateModule(address(role), stewardModule, true);

        role.transferOwnership(msg.sender);
        emit RoleCreated(token, address(role), name, symbol);
        return address(role);
    }
}