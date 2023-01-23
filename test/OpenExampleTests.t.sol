// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import { DSTest } from "../lib/forge-std/src/Test.sol";

import { AdditionExample } from "../src/AdditionExample.sol";

contract OpenInvariants is DSTest {

    AdditionExample foo;

    function setUp() external {
        foo = new AdditionExample();
    }

    function invariant_A() external {
        assertEq(foo.val1() + foo.val2(), foo.val3());
    }

    function invariant_B() external {
        assertGe(foo.val1() + foo.val2(), foo.val1());
    }

}
