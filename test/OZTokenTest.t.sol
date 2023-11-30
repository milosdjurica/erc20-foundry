// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {DeployOZToken} from "../script/DeployOZToken.s.sol";
import {OZToken} from "../src/OZToken.sol";

contract OZTokenTest is Test {
    OZToken public ozToken;
    DeployOZToken public deployer;

    address bob = makeAddr("bob");
    address lu = makeAddr("lu");
    address john = makeAddr("john");

    function setUp() public {
        deployer = new DeployOZToken();
        ozToken = deployer.run();
    }
}
