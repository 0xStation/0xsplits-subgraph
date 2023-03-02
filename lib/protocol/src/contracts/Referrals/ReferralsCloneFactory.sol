// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {Clones} from "openzeppelin/contracts/proxy/Clones.sol";

import {ConfigurablePrimitiveCloneFactory, Ownable} from "solkit/Configurable/CloneFactory.sol";
import {IDescriptor} from "solkit/Descriptor/IDescriptor.sol";
import {Action} from "solkit/AddressGraph/Interfaces.sol";

import {Referrals} from "./Referrals.sol";

contract ReferralsCloneFactory is ConfigurablePrimitiveCloneFactory {
    address public mintPolicy;

    constructor(
        address template_,
        address[] memory allowedContracts_,
        address mintPolicy_
    ) ConfigurablePrimitiveCloneFactory(template_, allowedContracts_) {
        updatePolicy(uint8(Action.Mint), mintPolicy_);
    }

    function updatePolicy(uint8 action, address implementation) public override onlyOwner {
        if (action == uint8(Action.Mint)) {
            mintPolicy = implementation;
        } else {
            revert("Must provide valid action type");
        }
        emit PolicyUpdated(action, implementation);
    }

    function create(string memory name, string memory symbol, address endorsementsToken, address pointsToken)
        external
        whenNotPaused
        returns (address)
    {
        address primitive = Clones.clone(template);
        
        Referrals(primitive).__Referrals_init(
            name,
            symbol,
            _allowedContracts,
            mintPolicy,
            endorsementsToken,
            pointsToken
        );

        Ownable(primitive).transferOwnership(msg.sender);
        emit ConfigurablePrimitiveCreated(primitive, IDescriptor(primitive).name(), IDescriptor(primitive).symbol());
        return primitive;
    }
}
