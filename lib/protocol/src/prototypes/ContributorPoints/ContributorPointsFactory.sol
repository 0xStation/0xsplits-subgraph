// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {Ownable} from "openzeppelin/contracts/access/Ownable.sol";

import {ContributorPoints} from "./ContributorPoints.sol";
import {AllowedModule} from "solkit/Mixins/AllowedModule.sol";

contract ContributorPointsFactory is Ownable {
    address public increasePolicy;
    address public decreasePolicy;
    address public stewardModule;
    
    event PointsCreated(address indexed token, address indexed points, string name, string symbol);

    constructor(
        address increasePolicy_,
        address decreasePolicy_,
        address stewardModule_
    ) {
        increasePolicy = increasePolicy_;
        decreasePolicy = decreasePolicy_;
        stewardModule = stewardModule_;
    }

    function updateIncreasePolicy(address implementation) public onlyOwner {
        increasePolicy = implementation;
    }

    function updateDecreasePolicy(address implementation) public onlyOwner {
        decreasePolicy = implementation;
    }

    function create(
        string calldata name,
        string calldata symbol,
        address token
    ) external returns (address) {
        ContributorPoints points = new ContributorPoints(
            name, 
            symbol,
            token,
            increasePolicy,
            decreasePolicy
        );

        AllowedModule(increasePolicy).updateModule(address(points), stewardModule, true);

        points.transferOwnership(msg.sender);
        emit PointsCreated(token, address(points), name, symbol);
        return address(points);
    }
}