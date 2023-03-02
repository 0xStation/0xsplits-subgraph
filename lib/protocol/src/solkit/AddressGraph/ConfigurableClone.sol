// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {ConfigurableUpgradeable} from "solkit/Configurable/ConfigurableUpgradeable.sol";
import {AddressGraphUpgradeable} from "./AddressGraphUpgradeable.sol";
import {Action, IPolicy, IConfigurableAddressGraph} from "./Interfaces.sol";

contract ConfigurableAddressGraphClone is ConfigurableUpgradeable, AddressGraphUpgradeable, IConfigurableAddressGraph {
    IPolicy internal _mintPolicy;
    IPolicy internal _burnPolicy;
    IPolicy internal _transferPolicy;

    // solhint-disable-next-line func-name-mixedcase
    function __ConfigurableAddressGraph_init(
        string memory name_,
        string memory symbol_,
        address[] memory allowedContracts_,
        address mintPolicy_,
        address burnPolicy_,
        address transferPolicy_
    ) public onlyInitializing {
        __AddressGraph_init(name_, symbol_);
        __Configurable_init(allowedContracts_);
        updatePolicy(uint8(Action.Mint), mintPolicy_);
        updatePolicy(uint8(Action.Burn), burnPolicy_);
        updatePolicy(uint8(Action.Transfer), transferPolicy_);
    }

    function policy(uint8 action) public view override returns (address) {
        if (Action(action) == Action.Mint) {
            return address(_mintPolicy);
        } else if (Action(action) == Action.Burn) {
            return address(_burnPolicy);
        } else if (Action(action) == Action.Transfer) {
            return address(_transferPolicy);
        } else {
            revert(ACTION_INVALID);
        }
    }

    function updatePolicy(uint8 action, address implementation) public override onlyOwner {
        if (Action(action) == Action.Mint) {
            _mintPolicy = IPolicy(implementation);
        } else if (Action(action) == Action.Burn) {
            _burnPolicy = IPolicy(implementation);
        } else if (Action(action) == Action.Transfer) {
            _transferPolicy = IPolicy(implementation);
        } else {
            revert(ACTION_INVALID);
        }
        emit PolicyUpdated(action, implementation);
    }

    function isAllowed(
        address operator,
        address sender,
        address from,
        address to,
        uint256 amount
    ) public view returns (bool) {
        if (from == address(0)) {
            return
                _mintPolicy.isAllowed(operator, sender, address(0), to, amount);
        } else if (to == address(0)) {
            return _burnPolicy.isAllowed(operator, sender, from, address(0), amount);
        } else {
            return
                _transferPolicy.isAllowed(operator, sender, from, to, amount);
        }
    }

    function _beforeTransfer(address sender, address from, address to, uint256 amount) internal view override {
        require(amount > 0, AMOUNT_ZERO);
        require(isAllowed(msg.sender, sender, from, to, amount), ACTION_FAILED);
    }
}