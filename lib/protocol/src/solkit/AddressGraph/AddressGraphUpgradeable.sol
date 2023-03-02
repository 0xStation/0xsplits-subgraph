// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {DescriptorUpgradeable} from "solkit/Descriptor/DescriptorUpgradeable.sol";
import {ScalarMetadata} from "solkit/Metadata/ScalarMetadata.sol";
import {IAddressGraph} from "./IAddressGraph.sol";

contract AddressGraphUpgradeable is DescriptorUpgradeable, ScalarMetadata, IAddressGraph {
    mapping(address => mapping(address => uint256)) internal _balances;

    // solhint-disable-next-line func-name-mixedcase
    function __AddressGraph_init(string memory name_, string memory symbol_) public {
        __Descriptor_init(name_, symbol_);
    }

    function balanceOf(address sender, address recipient) public view returns (uint256) {
        return _balances[sender][recipient];
    }

    function _transfer(address sender, address from, address to, uint256 amount) internal {
        require(sender != address(0), "transfer sender zero address");
        require(from != address(0), "transfer recipient from zero address");
        require(to != address(0), "transfer recipient to zero address");

        _beforeTransfer(sender, from, to, amount);

        uint256 fromBalance = _balances[sender][from];
        require(fromBalance >= amount, "transfer exceeds balance");
        unchecked {
            _balances[sender][from] = fromBalance - amount;
        }
        _balances[sender][to] += amount;

        emit Transfer(sender, from, to, amount);

        _afterTransfer(sender, from, to, amount);
    }

    function _mint(address sender, address to, uint256 amount) internal {
        require(sender != address(0), "transfer sender zero address");
        require(to != address(0), "transfer recipient to zero address");

        _beforeTransfer(sender, address(0), to, amount);

        _balances[sender][to] += amount;
        _total += amount;

        emit Transfer(sender, address(0), to, amount);

        _afterTransfer(sender, address(0), to, amount);
    }

    function _burn(address sender, address from, uint256 amount) internal {
        require(sender != address(0), "transfer sender zero address");
        require(from != address(0), "transfer recipient from zero address");

        _beforeTransfer(sender, from, address(0), amount);

        uint256 fromBalance = _balances[sender][from];
        require(fromBalance >= amount, "transfer exceeds balance");
        unchecked {
            _balances[sender][from] = fromBalance - amount;
        }
        _total -= amount;

        emit Transfer(sender, from, address(0), amount);

        _afterTransfer(sender, from, address(0), amount);
    }

    function _beforeTransfer(address sender, address from, address to, uint256 amount) internal virtual {}
    
    function _afterTransfer(address sender, address from, address to, uint256 amount) internal virtual {}
}