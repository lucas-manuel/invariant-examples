// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import { Basic4626Deposit } from "../src/Basic4626Deposit.sol";

import { ERC20 }         from "./ERC20.sol";
import { InvariantTest } from "./InvariantTest.sol";

contract BoundedPattern is InvariantTest {

    Basic4626Deposit public token;

    ERC20 public asset;

    function setUp() external {
        asset = new ERC20("Asset", "ASSET", 18);

        token = new Basic4626Deposit(address(asset), "Token", "TOKEN", 18);
    }

    function invariant_1() public {
        assertEq(token.name(), "Token");
    }

}
