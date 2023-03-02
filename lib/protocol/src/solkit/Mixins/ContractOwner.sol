// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {Ownable} from "openzeppelin/contracts/access/Ownable.sol";

abstract contract ContractOwner {
    modifier onlyOwnerOf(address ownable) {
        require(
            msg.sender == Ownable(ownable).owner(),
            "not owner"
        );
        _;
    }

    function ownerOf(address primitive) public view returns (address) {
        return Ownable(primitive).owner();
    }
}