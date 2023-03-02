// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {OwnableUpgradeable} from "openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import {IConfigurable} from "./IConfigurable.sol";

contract ConfigurableUpgradeable is IConfigurable, OwnableUpgradeable {
    string internal constant ACTION_INVALID="Configurable: Action type invalid";
    string internal constant ACTION_FAILED="Configurable: Action not allowed";
    string internal constant AMOUNT_ZERO="Configurable: Amount is zero";

    mapping(address => bool) internal _allowedContracts;

    // solhint-disable-next-line func-name-mixedcase
    function __Configurable_init(address[] memory allowedContracts_) public onlyInitializing {
        __Ownable_init();
        for (uint256 i; i < allowedContracts_.length; i++) {
            updateContract(allowedContracts_[i], true);
        }
    }

    function isAllowedContract(address implementation) public view returns (bool) {
        return _allowedContracts[implementation];
    }

    function updateContract(address implementation, bool allowed) public onlyOwner {
        _allowedContracts[implementation] = allowed;
        emit AllowedContractUpdated(implementation, allowed);
    }

    function swapContracts(address[] memory disallow, address[] memory allow) public onlyOwner {
        for (uint i=0; i < disallow.length; i++) {
            _allowedContracts[disallow[i]] = false;
            emit AllowedContractUpdated(disallow[i], false);
        }
        for (uint i=0; i < allow.length; i++) {
            _allowedContracts[allow[i]] = true;
            emit AllowedContractUpdated(allow[i], true);
        }
    }

    function policy(uint8 action) public view virtual returns (address) {}

    function updatePolicy(uint8 action, address implementation) public virtual onlyOwner {}
}