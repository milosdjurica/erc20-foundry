// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// OpenZepellin -> OZ
contract OZToken is ERC20 {
    constructor(uint initialSupply) ERC20("OZToken", "OZT") {
        _mint(msg.sender, initialSupply);
    }
}
