// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {INFTScalar} from "solkit/Primitive/INFTScalar.sol";

interface IContributorPoints is INFTScalar {
    function updateIncreasePolicy(address implementation) external returns (address);
    function updateDecreasePolicy(address implementation) external returns (address);

    function reset() external;

    function isAllowed(
        address operator,
        uint256 tokenId,
        uint256 oldValue,
        uint256 newValue
    ) external view returns (bool);
}
