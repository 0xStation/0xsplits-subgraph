// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {Ownable} from "openzeppelin/contracts/access/Ownable.sol";

import {NFTOption} from "solkit/Primitive/NFTOption.sol";
import {IContributorTicket} from "../Ticket/IContributorTicket.sol";
import {IRole} from "./IRole.sol";

contract Role is Ownable, NFTOption, IRole {
    address public selectPolicy;
    // tokenId => ticket is inactive
    mapping(uint256 => bool) internal _inactive;
    string public baseURI;

    constructor(string memory name_, string memory symbol_, address token_, address selectPolicy_) NFTOption(name_, symbol_, token_) {}

    function symbol() public view override returns (string memory) {
        return string(abi.encodePacked(super.symbol(), unicode"Ⓡ"));
    }

    function optionURI(uint256 optionId) external view override returns (string memory) {
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, "?ticket=", toAsciiString(nft()), "&option=", optionId)) : "" ;
    }

    modifier tokenExists(uint256 tokenId) {
        require(tokenId < IContributorTicket(nft()).counter(), "tokenId does not exist");
        _;
    }

    function updateBaseURI(string memory uri) external onlyOwner returns (bool) {
        baseURI = uri;
        return true;
    }

    function isActive(uint256 tokenId) external view tokenExists(tokenId) returns (bool) {
        return !_inactive[tokenId];
    }

    function updateActive(uint256 tokenId, bool active) external tokenExists(tokenId) returns (bool) {
        _inactive[tokenId] = !active;
        emit ActiveUpdated(tokenId, active);
        return active;
    }

    function updateSelectPolicy(address implementation) external onlyOwner returns (address) {
        selectPolicy = implementation;
        emit SelectPolicyUpdated(implementation);
        return implementation;
    }

    function isAllowed(address operator, uint256 tokenId, uint256 optionId) public view tokenExists(tokenId) returns (bool) {
        return IOptionPolicy(selectPolicy).isAllowed(operator, tokenId, optionId);
    }

    function toAsciiString(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2*i] = char(hi);
            s[2*i+1] = char(lo);
        }
        return string(abi.encodePacked("0x", s));
    }

    function char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }


    function _beforeOptionSelect(uint256 tokenId, uint256 optionId) internal view override {
        require(isAllowed(msg.sender, tokenId, optionId), "option selection not allowed");
    }
}

interface IOptionPolicy {
    function isAllowed(address operator, uint256 tokenId, uint256 optionId) external view returns (bool);
}