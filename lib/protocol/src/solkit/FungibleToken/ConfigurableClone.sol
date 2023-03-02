// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {ERC20PermitUpgradeable} from "openzeppelin/contracts-upgradeable/token/ERC20/extensions/draft-ERC20PermitUpgradeable.sol";
import {ConfigurableUpgradeable} from "solkit/Configurable/ConfigurableUpgradeable.sol";

import {Action, IPolicy, IConfigurableFungibleToken} from "./Interfaces.sol";

contract ConfigurableFungibleTokenClone is ConfigurableUpgradeable, ERC20PermitUpgradeable, IConfigurableFungibleToken {
    IPolicy internal _mintPolicy;
    IPolicy internal _burnPolicy;
    IPolicy internal _transferPolicy;

    // solhint-disable-next-line func-name-mixedcase
    function __ConfigurableFungibleToken_init(
        string memory name_,
        string memory symbol_,
        address[] memory allowedContracts_,
        address mintPolicy_,
        address burnPolicy_,
        address transferPolicy_
    ) public onlyInitializing {
        __ERC20_init(name_, symbol_);
        __ERC20Permit_init(name_);
        __Configurable_init(allowedContracts_);
        updatePolicy(uint8(Action.Mint), mintPolicy_);
        updatePolicy(uint8(Action.Burn), burnPolicy_);
        updatePolicy(uint8(Action.Transfer), transferPolicy_);
    }

    function policy(uint8 action) public view override returns (address) {
        if (action == uint8(Action.Mint)) {
            return address(_mintPolicy);
        } else if (action == uint8(Action.Burn)) {
            return address(_burnPolicy);
        } else if (action == uint8(Action.Transfer)) {
            return address(_transferPolicy);
        } else {
            revert(ACTION_INVALID);
        }
    }

    function updatePolicy(uint8 action, address implementation) public override onlyOwner {
        if (action == uint8(Action.Mint)) {
            _mintPolicy = IPolicy(implementation);
        } else if (action == uint8(Action.Burn)) {
            _burnPolicy = IPolicy(implementation);
        } else if (action == uint8(Action.Transfer)) {
            _transferPolicy = IPolicy(implementation);
        } else {
            revert(ACTION_INVALID);
        }
        emit PolicyUpdated(action, implementation);
    }

    function isAllowed(
        address operator,
        address sender,
        address recipient,
        uint256 amount
    ) public view returns (bool) {
        if (sender == address(0)) {
            return
                _mintPolicy.isAllowed(operator, address(0), recipient, amount);
        } else if (recipient == address(0)) {
            return _burnPolicy.isAllowed(operator, sender, address(0), amount);
        } else {
            return
                _transferPolicy.isAllowed(operator, sender, recipient, amount);
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal view override {
        require(amount > 0, AMOUNT_ZERO);
        require(isAllowed(msg.sender, from, to, amount), ACTION_FAILED);
    }

    function mint(uint256 amount) public returns (bool) {
        _mint(msg.sender, amount);
        return true;
    }

    function mintTo(address account, uint256 amount) public returns (bool) {
        _mint(account, amount);
        return true;
    }

    function burn(uint256 amount) public returns (bool) {
        _burn(msg.sender, amount);
        return true;
    }

    function burnFrom(address account, uint256 amount) public returns (bool) {
        uint256 currentAllowance = allowance(account, msg.sender);
        if (currentAllowance != type(uint256).max) {
            require(
                currentAllowance >= amount,
                "ERC20: Transfer amount exceeds allowance"
            );
            unchecked {
                _approve(account, msg.sender, currentAllowance - amount);
            }
        }

        _burn(account, amount);
        return true;
    }
}
