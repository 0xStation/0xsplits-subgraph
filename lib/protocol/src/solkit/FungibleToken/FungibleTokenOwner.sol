// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {ContractOwner} from "solkit/Mixins/ContractOwner.sol";

import {IConfigurableFungibleToken} from "solkit/FungibleToken/Interfaces.sol";

contract FungibleTokenOwnerModule is ContractOwner {
    function mintTokens(address token, address account, uint256 amount) external onlyOwnerOf(token) {
        IConfigurableFungibleToken(token).mintTo(account, amount);
    }

    function mintManyTokens(address token, address[] calldata accounts, uint256[] calldata amounts) external onlyOwnerOf(token) {
        require(accounts.length == amounts.length, "accounts and amounts lengths differ");
        for (uint i=0; i < accounts.length; i++) {
            IConfigurableFungibleToken(token).mintTo(accounts[i], amounts[i]);
        }
    }
}