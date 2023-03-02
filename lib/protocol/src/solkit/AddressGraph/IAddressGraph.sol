// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

interface IAddressGraph {
    event Transfer(address indexed sender, address indexed from, address indexed to, uint256 amount);

    function balanceOf(address sender, address recipient) external view returns (uint256);
}