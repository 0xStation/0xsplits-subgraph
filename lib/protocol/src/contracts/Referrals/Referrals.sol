// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {ConfigurableAddressGraphClone} from "solkit/AddressGraph/ConfigurableClone.sol";
import {IConfigurableFungibleToken} from "solkit/FungibleToken/Interfaces.sol";

import {IReferrals} from "./IReferrals.sol";

/*
Modules:
  WaitingRoom
Policies:
  mint -> AllowedContract
  burn -> NeverAllowed
  transfer -> NeverAllowed
*/
contract Referrals is ConfigurableAddressGraphClone, IReferrals {
    address public endorsementsToken;
    address public pointsToken;

    // solhint-disable-next-line func-name-mixedcase
    function __Referrals_init(
        string memory name_,
        string memory symbol_,
        address[] memory allowedContracts_,
        address mintPolicy_,
        address endorsementsToken_,
        address pointsToken_
    ) public initializer {
        __ConfigurableAddressGraph_init(name_, symbol_, allowedContracts_, mintPolicy_, address(0), address(0));
        updateEndorsementsToken(endorsementsToken_);
        updatePointsToken(pointsToken_);
    }

    function symbol() public view override returns (string memory) {
        return string(abi.encodePacked(_symbol, unicode"🅡"));
    }

    function updateEndorsementsToken(address implementation) public onlyOwner returns (address) {
        endorsementsToken = implementation;
        emit EndorsementTokenUpdated(implementation);
        return implementation;
    }

    function updatePointsToken(address implementation) public onlyOwner returns (address) {
        pointsToken = implementation;
        emit PointsTokenUpdated(implementation);
        return implementation;
    }

    function endorseFrom(address sender, address recipient, uint256 amount) 
        external
        returns (bool)
    {
        require(sender != recipient, "Referrals: Sender and recipient equal");
        _mint(sender, recipient, amount);
        return true;
    }
}