// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {ERC721} from "openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "openzeppelin/contracts/access/Ownable.sol";

import {IRenderer} from "./Renderer/IRenderer.sol";

contract ContributorTicket is Ownable, ERC721 {
    uint256 public counter;
    IERC721Policy public mintPolicy;
    IERC721Policy public burnPolicy;
    IERC721Policy public transferPolicy;
    IRenderer public renderer;

    event MintPolicyUpdated(address indexed implementation);
    event BurnPolicyUpdated(address indexed implementation);
    event TransferPolicyUpdated(address indexed implementation);
    event RendererUpdated(address indexed implementation);

    constructor(
        string memory name_,
        string memory symbol_,
        address mintPolicy_,
        address burnPolicy_,
        address transferPolicy_,
        address renderer_
    ) Ownable() ERC721(name_, symbol_) {
        updateMintPolicy(mintPolicy_);
        updateBurnPolicy(burnPolicy_);
        updateTransferPolicy(transferPolicy_);
        updateRenderer(renderer_);
    }

    function updateMintPolicy(address implementation) public onlyOwner {
        mintPolicy = IERC721Policy(implementation);
        emit MintPolicyUpdated(implementation);
    }

    function updateBurnPolicy(address implementation) public onlyOwner {
        burnPolicy = IERC721Policy(implementation);
        emit BurnPolicyUpdated(implementation);
    }

    function updateTransferPolicy(address implementation) public onlyOwner {
        transferPolicy = IERC721Policy(implementation);
        emit TransferPolicyUpdated(implementation);
    }

    function updateRenderer(address implementation) public onlyOwner {
        renderer = IRenderer(implementation);
        emit RendererUpdated(implementation);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return renderer.tokenURI(tokenId);
    }
 
    function mintTo(address account) public returns (bool) {
        _mint(account, counter);
        return true;
    }

    function isAllowed(
        address operator,
        address sender,
        address recipient,
        uint256 tokenId
    ) public view returns (bool) {
        if (sender == address(0)) {
            return
                mintPolicy.isAllowed(operator, address(0), recipient, tokenId);
        } else if (recipient == address(0)) {
            return burnPolicy.isAllowed(operator, sender, address(0), tokenId);
        } else {
            return
                transferPolicy.isAllowed(operator, sender, recipient, tokenId);
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal view override {
        require(isAllowed(msg.sender, from, to, tokenId), "requested operation not allowed");
    }

    function _afterTokenTransfer(
        address from,
        address,
        uint256
    ) internal override {
        if (from == address(0)) {
            counter += 1;
        }
    }
}

interface IERC721Policy {
    function isAllowed(
        address operator,
        address from,
        address to,
        uint256 tokenId
    ) external view returns (bool);
}