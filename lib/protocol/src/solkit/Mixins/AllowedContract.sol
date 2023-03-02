// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {IConfigurable} from "solkit/Configurable/IConfigurable.sol";
import {SymbolErrorMessage} from "./SymbolErrorMessage.sol";

abstract contract AllowedContract is SymbolErrorMessage {
    function isOperatorAllowedContract(address operator) internal view returns (bool) {
        require(IConfigurable(msg.sender).isAllowedContract(operator), withMessage(msg.sender, "Operator must be allowed contract"));
        return true;
    }
}