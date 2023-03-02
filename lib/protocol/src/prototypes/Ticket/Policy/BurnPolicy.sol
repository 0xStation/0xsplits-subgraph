// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {IERC721Policy} from "../ContributorTicket.sol";

contract TicketBurnPolicy is IERC721Policy {
    function isAllowed(
        address,
        address, // address(0)
        address,
        uint256
    ) external pure override returns (bool) {
        return false;
    }
}