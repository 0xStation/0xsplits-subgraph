// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {ConfigurableFungibleTokenClone} from "solkit/FungibleToken/ConfigurableClone.sol";

/*
Modules:
  WaitingRoom (trusts will check that associated Referrals is allowed)
Policies:
  mint -> AllowedContract
  burn -> NeverAllowed
  transfer -> NeverAllowed
*/
contract Points is ConfigurableFungibleTokenClone {

  // solhint-disable-next-line func-name-mixedcase
    function __Points_init(
        string memory name_,
        string memory symbol_,
        address[] memory allowedContracts_,
        address mintPolicy_,
        address burnPolicy_,
        address transferPolicy_
    ) public initializer {
      __ConfigurableFungibleToken_init(name_, symbol_, allowedContracts_, mintPolicy_, burnPolicy_, transferPolicy_);
    }

    function symbol() public view override returns (string memory) {
        return string(abi.encodePacked(super.symbol(), unicode"🅟"));
    }

    function decimals() public pure override returns (uint8) {
        return 6;
    }
}
