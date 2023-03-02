// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {IDescriptor} from "./IDescriptor.sol";

contract Descriptor is IDescriptor {
    string internal _name;
    string internal _symbol;

    constructor(string memory name_, string memory symbol_) {
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