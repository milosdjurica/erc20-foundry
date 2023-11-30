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

    uint public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOZToken();
        ozToken = deployer.run();

        vm.prank(msg.sender);
        ozToken.transfer(bob, STARTING_BALANCE);
        vm.prank(msg.sender);
        ozToken.transfer(lu, STARTING_BALANCE);
        vm.prank(msg.sender);
        ozToken.transfer(john, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, ozToken.balanceOf(bob));
    }

    function testAllowancesWorks() public {
        // transferFrom()
        uint initialAllowance = 1000;

        // Bob approves John to spend tokens on his behalf
        vm.prank(bob);
        ozToken.approve(john, initialAllowance);

        uint transferAmount = 500;

        vm.prank(john);
        ozToken.transferFrom(bob, john, transferAmount);

        assertEq(ozToken.balanceOf(john), STARTING_BALANCE + transferAmount);
        assertEq(ozToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }
}
