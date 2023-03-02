// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

interface IContributorTicket {
    function counter() external view returns (uint256);

    function mintTo(address account) external returns (bool);
    
    function isAllowed(
        address operator,
        address sender,
        address recipient,
        uint256 tokenId
    ) external view returns (bool);
}
