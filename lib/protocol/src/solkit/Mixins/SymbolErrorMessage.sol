// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {IDescriptor} from "solkit/Descriptor/IDescriptor.sol";

abstract contract SymbolErrorMessage {
    function withMessage(address primitive, string memory message) internal view returns (string memory) {
        return string(abi.encodePacked(IDescriptor(primitive).symbol(), ": ", message));
    }
}