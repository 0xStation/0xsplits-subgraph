// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

interface IConfigurable {
    event AllowedContractUpdated(address indexed implementation, bool allowed);
    event PolicyUpdated(uint8 indexed action, address indexed implementation);

    function isAllowedContract(address implementation) external view returns (bool);

    function policy(uint8 action) external view returns (address);

    function updateContract(address implementation, bool allowed) external;

    function swapContracts(address[] memory disallow, address[] memory allow) external;

    function updatePolicy(uint8 action, address implementation) external;
}