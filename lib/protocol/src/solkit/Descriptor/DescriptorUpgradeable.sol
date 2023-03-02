// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {Initializable} from "openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import {IDescriptor} from "./IDescriptor.sol";

contract DescriptorUpgradeable is IDescriptor, Initializable {
    string internal _name;
    string internal _symbol;

    // solhint-disable-next-line func-name-mixedcase
    function __Descriptor_init(string memory name_, string memory symbol_) public onlyInitializing {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }
}