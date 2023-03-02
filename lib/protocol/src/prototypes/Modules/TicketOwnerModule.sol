// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {ContractOwner} from "solkit/Mixins/ContractOwner.sol";

import {IContributorTicket} from "../Ticket/IContributorTicket.sol";

contract TicketOwnerModule is ContractOwner {
    function mintTicket(address ticket, address account) external onlyOwnerOf(ticket) {
        IContributorTicket(ticket).mintTo(account);
    }
}