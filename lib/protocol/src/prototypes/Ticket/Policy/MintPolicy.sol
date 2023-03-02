// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {IERC721Policy} from "../ContributorTicket.sol";
import {AllowedModule} from "solkit/Mixins/AllowedModule.sol";
import {TicketHolder} from "solkit/Mixins/TicketHolder.sol";

contract TicketMintPolicy is IERC721Policy, AllowedModule, TicketHolder {
    function isAllowed(
        address operator,
        address, // address(0)
        address recipient,
        uint256
    ) external view override returns (bool) {
        require(isAllowedModule(operator), "operator must be allowed module");
        require(!holdsTicket(recipient), "recipient cannot hold ticket more than one ticket");
        return true;
    }
}