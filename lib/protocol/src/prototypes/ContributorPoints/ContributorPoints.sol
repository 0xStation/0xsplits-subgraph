// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {Ownable} from "openzeppelin/contracts/access/Ownable.sol";

import { NFTScalar } from "solkit/Primitive/NFTScalar.sol";

contract ContributorPoints is Ownable, NFTScalar {
    address public increasePolicy;
    address public decreasePolicy;

    constructor(string memory name_, string memory symbol_, address token_, address increasePolicy_, address decreasePolicy_) 
        Ownable() 
        NFTScalar(name_, symbol_, token_) 
    {
        updateIncreasePolicy(increasePolicy_);
        updateDecreasePolicy(decreasePolicy_);
    }

    function symbol() public view override returns (string memory) {
        return string(abi.encodePacked(super.symbol(), unicode"Ⓟ"));
    }

    function updateIncreasePolicy(address implementation) public returns (address) {
        increasePolicy = implementation;
        return increasePolicy;
    }

    function updateDecreasePolicy(address implementation) public returns (address) {
        decreasePolicy = implementation;
        return decreasePolicy;
    }

    function isAllowed(address operator, uint256 tokenId, uint256 oldValue, uint256 newValue) public view returns (bool) {
        if (newValue > oldValue) {
            return ScalarPolicy(increasePolicy).isAllowed(operator, tokenId, oldValue, newValue);
        } else if (newValue < oldValue) {
            return ScalarPolicy(decreasePolicy).isAllowed(operator, tokenId, oldValue, newValue);
        } else {
            return false;
        }
    }

    function _afterValueUpdate(uint256 tokenId, uint256 oldValue, uint256 newValue) internal view override {
        if (newValue > oldValue) {
            require(ScalarPolicy(increasePolicy).isAllowed(msg.sender, tokenId, oldValue, newValue), "Increase not allowed");
        } else if (newValue < oldValue) {
            require(ScalarPolicy(decreasePolicy).isAllowed(msg.sender, tokenId, oldValue, newValue), "Decrease not allowed");
        } else {
            revert("Value unchanged");
        }
    }

    function reset(uint256 tokenId) external {
        _reset(tokenId, 0);
    }
}

interface ScalarPolicy {
    function isAllowed(address operator, uint256 tokenId, uint256 oldValue, uint256 newValue) external view returns (bool);
}