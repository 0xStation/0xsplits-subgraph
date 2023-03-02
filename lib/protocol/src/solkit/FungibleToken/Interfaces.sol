// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {IERC20Metadata} from "openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

import {IConfigurable} from "solkit/Configurable/IConfigurable.sol";

enum Action {
    Mint,
    Burn,
    Transfer
}

interface IPolicy {
    function isAllowed(
        address operator,
        address sender,
        address recipient,
        uint256 amount
    ) external view returns (bool);
}

interface IConfigurableFungibleToken {
    function isAllowed(address operator, address from, address to, uint256 amount) external view returns (bool);

    function mintTo(address account, uint256 amount) external returns (bool);

    function burn(uint256 amount) external returns (bool);

    function burnFrom(address account, uint256 amount) external returns (bool);
}

interface IConfigurableFungibleTokenFull is IConfigurable, IERC20Metadata, IConfigurableFungibleToken {}