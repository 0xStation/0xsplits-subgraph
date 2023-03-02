// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {IRenderer} from "./IRenderer.sol";

contract FixedRenderer {
    function tokenURI(uint256) public pure returns (string memory) {
        // @0xSTATION pfp
        return "https://pbs.twimg.com/profile_images/1465787628553310211/DOMgJi5d_400x400.jpg";
    }
}