// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {IERC721} from "openzeppelin/contracts/token/ERC721/IERC721.sol";

abstract contract TicketHolder {
    modifier isTicketHolder(address ticket, uint256 id) {
        require(msg.sender == IERC721(ticket).ownerOf(id), "sender not holder of ticket");
        _;
    }

    function holderOf(address ticket, uint256 id) internal view returns (address) {
        return IERC721(ticket).ownerOf(id);
    }

    function holdsTicket(address account) public view returns (bool) {
        return IERC721(msg.sender).balanceOf(account) > 0;
    }
}