// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import { INFTMetadata } from "solkit/Metadata/INFTMetadata.sol";

interface INFTOption {
    event Select(uint256 indexed tokenId, uint256 indexed optionId);

    function selectionOf(uint256 tokenId) external view returns (uint256);

    function selectionCount(uint256 optionId) external view returns (uint256);

    function optionURI(uint256 optionId) external view returns (string memory);
    
    function select(uint256 tokenId, uint256 optionId) external returns (uint256);
}

interface INFTOptionFull is INFTMetadata, INFTOption {}