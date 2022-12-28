// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import { ERC20 as SolmateERC20 } from "../lib/solmate/src/tokens/ERC20.sol";

import { Basic4626Deposit } from "../src/Basic4626Deposit.sol";

import { InvariantTest } from "./InvariantTest.sol";

contract ERC20 is SolmateERC20 {
    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) SolmateERC20(name_, symbol_, decimals_) { }
}
