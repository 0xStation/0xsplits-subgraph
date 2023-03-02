// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

interface IScalarMetadata {
    function decimals() external view returns (uint256);

    function total() external view returns (uint256);
}