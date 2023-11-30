// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Script} from "../lib/forge-std/src/Script.sol";
import {OZToken} from "../src/OZToken.sol";

contract DeployOZToken is Script {
    uint public constant INITIAL_SUPPLY = 1000 ether;

    function run() external {
        vm.startBroadcast();
        new OZToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
    }
}
