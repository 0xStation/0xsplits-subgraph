// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {Clones} from "openzeppelin/contracts/proxy/Clones.sol";

import {ConfigurablePrimitiveCloneFactory, Ownable} from "solkit/Configurable/CloneFactory.sol";
import {IDescriptor} from "solkit/Descriptor/IDescriptor.sol";
import {Action} from "solkit/FungibleToken/Interfaces.sol";

import {Endorsements} from "./Endorsements.sol";

contract EndorsementsCloneFactory is ConfigurablePrimitiveCloneFactory {
    address public mintPolicy;
    address public burnPolicy;
    address public transferPolicy;

    constructor(
        address template_,
        address[] memory allowedContracts_,
        address mintPolicy_,
        address burnPolicy_,
        address transferPolicy_
    ) ConfigurablePrimitiveCloneFactory(template_, allowedContracts_) {
        updatePolicy(uint8(Action.Mint), mintPolicy_);
        updatePolicy(uint8(Action.Burn), burnPolicy_);
        updatePolicy(uint8(Action.Transfer), transferPolicy_);
    }

    function updatePolicy(uint8 action, address implementation) public override onlyOwner {
        if (action == uint8(Action.Mint)) {
            mintPolicy = implementation;
        } else if (action == uint8(Action.Burn)) {
            burnPolicy = implementation;
        } else if (action == uint8(Action.Transfer)) {
            transferPolicy = implementation;
        } else {
            revert("Must provide valid action type");
        }
        emit PolicyUpdated(action, implementation);
    }

    function create(string memory name, string memory symbol)
        external
        whenNotPaused
        returns (address)
    {
        address primitive = Clones.clone(template);

        Endorsements(primitive).__Endorsements_init(
            name,
            symbol,
            _allowedContracts,
            mintPolicy,
            burnPolicy,
            transferPolicy
        );

        Ownable(primitive).transferOwnership(msg.sender);
        emit ConfigurablePrimitiveCreated(primitive, IDescriptor(primitive).name(), IDescriptor(primitive).symbol());
        return primitive;
    }
}