// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {INFTOptionFull} from "solkit/Primitive/INFTOption.sol";

interface IRole {
    event SelectPolicyUpdated(address indexed implementation);
    event ActiveUpdated(uint256 indexed tokenId, bool active);
    
    function selectPolicy() external view returns (address);

    function isActive(uint256 tokenId) external view returns (bool);

    function updateActive(uint256 tokenId, bool active) external returns (bool);

    function updateSelectPolicy(address implementation) external returns (address);

    function isAllowed(address operator, uint256 tokenId, uint256 optionId) external view returns (bool);
}

interface IRoleFull is INFTOptionFull {
    function owner() external view returns (address);

    function transferOwnership(address newOwner) external returns (bool);
}