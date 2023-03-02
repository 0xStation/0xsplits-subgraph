// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {IERC721Policy} from "../ContributorTicket.sol";
import {AlwaysAllowed} from "solkit/Mixins/AlwaysAllowed.sol";

contract TicketTransferPolicy is IERC721Policy, AlwaysAllowed {
    function isAllowed(
        address,
        address, // address(0)
        address,
        uint256
    ) external pure override returns (bool) {
        return alwaysAllowed();
    }
}