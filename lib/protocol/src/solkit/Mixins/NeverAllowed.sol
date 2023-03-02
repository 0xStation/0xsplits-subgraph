// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {SymbolErrorMessage} from "./SymbolErrorMessage.sol";

abstract contract NeverAllowed is SymbolErrorMessage {
    function revertWithNeverAllowed() internal view returns (bool) {    
        revert(withMessage(msg.sender, "Action is never allowed"));
    }
}