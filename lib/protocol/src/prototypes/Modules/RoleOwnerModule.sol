// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {ContractOwner} from "solkit/Mixins/ContractOwner.sol";

import {INFTOption} from "solkit/Primitive/INFTOption.sol";

contract RoleOwnerModule is ContractOwner {
    function selectRole(address role, uint256 tokenId, uint256 optionId) external onlyOwnerOf(role) {
        INFTOption(role).select(tokenId, optionId);
    }
}