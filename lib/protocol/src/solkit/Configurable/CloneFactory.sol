// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {Ownable} from "openzeppelin/contracts/access/Ownable.sol";
import {Pausable} from "openzeppelin/contracts/security/Pausable.sol";

abstract contract ConfigurablePrimitiveCloneFactory is Ownable, Pausable {
    address public template;
    address[] internal _allowedContracts;

    event TemplateUpdated(address indexed implementation);
    event AllowedContractsUpdated(address[] implementations);
    event PolicyUpdated(uint8 action, address implementation);
    event ConfigurablePrimitiveCreated(address indexed primitive, string name, string symbol);

    constructor(
        address template_,
        address[] memory allowedContracts_
    ) Pausable() {
        updateTemplate(template_);
        updateAllowedContracts(allowedContracts_);
    }

    function allowedContracts() external view returns (address[] memory) {
        return _allowedContracts;
    }

    function updateTemplate(address implementation) public onlyOwner {
        template = implementation;
        emit TemplateUpdated(implementation);
    }

    function updateAllowedContracts(address[] memory implementations) public onlyOwner {
        _allowedContracts = implementations;
        emit AllowedContractsUpdated(implementations);
    }

    function updatePolicy(uint8 action, address implementation) public virtual {}

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    fallback() external {}
}