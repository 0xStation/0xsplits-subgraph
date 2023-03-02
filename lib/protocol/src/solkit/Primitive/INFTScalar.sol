// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import { IDescriptor } from "solkit/Descriptor/IDescriptor.sol";
import { INFTMetadata } from "solkit/Metadata/INFTMetadata.sol";
import { IScalarMetadata } from "solkit/Metadata/IScalarMetadata.sol";

interface INFTScalar {
    event ValueUpdated(uint256 indexed tokenId, uint256 oldValue, uint256 newValue, int256 change);

    function valueOf(uint256 tokenId) external view returns (uint256);

    function increaseValue(uint256 tokenId, uint256 amount) external returns (uint256);

    function decreaseValue(uint256 tokenId, uint256 amount) external returns (uint256);
}

interface INFTScalarFull is IDescriptor, INFTMetadata, IScalarMetadata, INFTScalar {}