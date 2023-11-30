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

    function testNegativeAllowance() public {
        uint initialAllowance = 100;
        vm.prank(bob);
        ozToken.approve(john, initialAllowance);

        uint transferAmount = 200;

        vm.prank(john);
        // This should revert since the allowance is not sufficient
        vm.expectRevert();
        ozToken.transferFrom(bob, john, transferAmount);
    }

    function testMultipleApprovals() public {
        uint initialAllowance1 = 100;
        uint initialAllowance2 = 200;

        vm.prank(bob);
        ozToken.approve(john, initialAllowance1);

        vm.prank(bob);
        ozToken.approve(lu, initialAllowance2);

        assertEq(ozToken.allowance(bob, john), initialAllowance1);
        assertEq(ozToken.allowance(bob, lu), initialAllowance2);
    }

    function testTransferToZeroAddress() public {
        uint transferAmount = 50;

        vm.prank(msg.sender);
        // This should revert since the recipient address is zero
        vm.expectRevert();
        ozToken.transfer(address(0), transferAmount);
    }

    function testTransfer() public {
        uint amount = 1000;
        address receiver = address(0x1);
        vm.prank(msg.sender);
        ozToken.transfer(receiver, amount);
        assertEq(ozToken.balanceOf(receiver), amount);
    }

    function testBalanceAfterTransfer() public {
        uint amount = 1000;
        address receiver = address(0x1);
        console.log("msg.sender has : ", ozToken.balanceOf(msg.sender));
        uint initialBalance = ozToken.balanceOf(msg.sender);
        vm.prank(msg.sender);
        ozToken.transfer(receiver, amount);
        console.log("msg.sender has : ", ozToken.balanceOf(msg.sender));
        assertEq(ozToken.balanceOf(msg.sender), initialBalance - amount);
    }
}
