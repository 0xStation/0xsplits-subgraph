// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {Ownable} from "openzeppelin/contracts/access/Ownable.sol";

import {ContributorTicket} from "./ContributorTicket.sol";
import {AllowedModule} from "solkit/Mixins/AllowedModule.sol";

contract ContributorTicketFactory is Ownable {
    address public mintPolicy;
    address public burnPolicy;
    address public transferPolicy;
    address public renderer;
    address public stewardModule;
    
    event ContributorTicketCreated(address indexed ticket, string name, string symbol);

    constructor(
        address mintPolicy_,
        address burnPolicy_,
        address transferPolicy_,
        address renderer_,
        address stewardModule_
    ) {
        mintPolicy = mintPolicy_;
        burnPolicy = burnPolicy_;
        transferPolicy = transferPolicy_;
        renderer = renderer_;
        stewardModule = stewardModule_;
    }

    function updateMintPolicy(address implementation) public onlyOwner {
        mintPolicy = implementation;
    }

    function updateBurnPolicy(address implementation) public onlyOwner {
        burnPolicy = implementation;
    }

    function updateTransferPolicy(address implementation) public onlyOwner {
        transferPolicy = implementation;
    }

    function updateOwnerMint(address implementation) public onlyOwner {
        stewardModule = implementation;
    }

    function create(
        string calldata name,
        string calldata symbol
    ) external returns (address) {
        ContributorTicket ticket = new ContributorTicket(
            name, 
            symbol,
            mintPolicy,
            burnPolicy,
            transferPolicy,
            renderer
        );

        AllowedModule(mintPolicy).updateModule(address(ticket), stewardModule, true);

        ticket.transferOwnership(msg.sender);
        emit ContributorTicketCreated(address(ticket), name, symbol);
        return address(ticket);
    }
}