// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

enum Action {
    Mint,
    Burn,
    Transfer
}

interface IPolicy {
    function isAllowed(
        address operator,
        address sender,
        address from,
        address to,
        uint256 amount
    ) external view returns (bool);
}

interface IConfigurableAddressGraph {
    function isAllowed(address operator, address sender, address from, address to, uint256 amount) external view returns (bool);
}