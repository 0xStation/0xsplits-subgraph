// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

interface IReferrals {
    event EndorsementTokenUpdated(address indexed implementation);
    event PointsTokenUpdated(address indexed implementation);

    function endorsementsToken() external view returns (address);

    function pointsToken() external view returns (address);

    function updateEndorsementsToken(address implementation) external returns (address);

    function updatePointsToken(address implementation) external returns (address);

    function endorseFrom(address from, address to, uint256 amount) external returns (bool);
}
