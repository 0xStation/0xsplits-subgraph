// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {Ownable} from "openzeppelin/contracts/access/Ownable.sol";
import {IERC721} from "openzeppelin/contracts/token/ERC721/IERC721.sol";

import {IRenderer} from "./IRenderer.sol";

contract StationOwnerAddressRenderer is Ownable, IRenderer {
    string public baseURI;

    constructor() {
        baseURI = "https://station.express/api/nft/view/ticket";
    }

    function updateBaseURI(string memory uri) external onlyOwner {
        baseURI = uri;
    }

    function tokenURIOf(address ticket, uint256 tokenId) public view returns (string memory) {
        return string(abi.encodePacked(baseURI, "?ticket=", toAsciiString(ticket), "&owner=", toAsciiString(IERC721(ticket).ownerOf(tokenId))));
    }

    function tokenURI(uint256 tokenId) external view returns (string memory) {
        return tokenURIOf(msg.sender, tokenId);
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
}