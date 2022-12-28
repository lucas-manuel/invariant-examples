// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import { Basic4626Deposit } from "../src/Basic4626Deposit.sol";

import { InvariantTest } from "./InvariantTest.sol";

contract BoundedPattern is InvariantTest {

    Basic4626Deposit public token;

}
