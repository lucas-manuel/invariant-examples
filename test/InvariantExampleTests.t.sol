// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import { console }       from "../lib/forge-std/src/console.sol";
import { InvariantTest } from "../lib/forge-std/src/InvariantTest.sol";
import { DSTest }        from "../lib/forge-std/src/Test.sol";

import { Basic4626Deposit } from "../src/Basic4626Deposit.sol";

import {
    IERC20Like,
    ILpHandlerLike,
    ITokenLike,
    ITransferHandlerLike
} from "./Interfaces.sol";

import { ERC20 } from "./ERC20.sol";

import { BoundedLpHandler, UnboundedLpHandler } from "./LpHandler.sol";

import { BoundedTransferHandler, UnboundedTransferHandler } from "./TransferHandler.sol";

contract Basic4626InvariantBase is DSTest, InvariantTest {

    ITokenLike public token;

    IERC20Like public asset;

    ILpHandlerLike       public lpHandler;
    ITransferHandlerLike public transferHandler;

    uint256 public currentTimestamp;

    function assert_invariant_A() public {
        assertGe(token.totalAssets(), token.totalSupply());
    }

    function assert_invariant_B() public {
        assertEq(token.totalAssets(), asset.balanceOf(address(token)));
    }

    function assert_invariant_C() public {
        assertEq(lpHandler.sumBalance(), token.totalSupply());
    }

    function assert_invariant_D_E_F() public {
        uint256 sumAssets;

        uint256 numLps      = lpHandler.numLps();
        uint256 totalAssets = token.totalAssets();
        uint256 totalSupply = token.totalSupply();

        if (totalAssets == 0 || totalSupply == 0) return;

        for (uint256 i = 0; i < numLps; i++) {
            address lp = lpHandler.lps(i);

            uint256 assetBalance = token.convertToAssets(token.balanceOf(lp));

            assertTrue(assetBalance >= token.balanceOf(lp));

            sumAssets += assetBalance;
        }

        assertTrue((token.totalAssets() - sumAssets) <= numLps);
    }

}

contract BoundedPatternInvariants is Basic4626InvariantBase {

    function setUp() external {
        asset = IERC20Like(address(new ERC20("Asset", "ASSET", 18)));

        token = ITokenLike(address(new Basic4626Deposit(address(asset), "Token", "TOKEN", 18)));

        lpHandler = ILpHandlerLike(address(new BoundedLpHandler(address(asset), address(token), 50)));

        transferHandler = ITransferHandlerLike(address(new BoundedTransferHandler(address(asset), address(token))));

        excludeContract(address(asset));
        excludeContract(address(token));

        targetSender(address(0x1234));
    }

    function invariant_A() external { assert_invariant_A(); }
    function invariant_B() external { assert_invariant_B(); }
    function invariant_C() external { assert_invariant_C(); }

    function invariant_D_E_F() external {
        assert_invariant_D_E_F();
    }

    function invariant_call_summary() external view {
        console.log("\nCall Summary\n");
        console.log("boundedLp.addLp         ", lpHandler.numCalls("boundedLp.addLp"));
        console.log("boundedLp.deposit       ", lpHandler.numCalls("boundedLp.deposit"));
        console.log("boundedLp.transfer      ", lpHandler.numCalls("boundedLp.transfer"));
        console.log("boundedTransfer.transfer", transferHandler.numCalls("boundedTransfer.transfer"));
        console.log("------------------");
        console.log(
            "Sum",
            lpHandler.numCalls("boundedLp.addLp") +
            lpHandler.numCalls("boundedLp.deposit") +
            lpHandler.numCalls("boundedLp.transfer") +
            transferHandler.numCalls("boundedTransfer.transfer")
        );
    }

}

contract UnboundedPatternInvariants is Basic4626InvariantBase {

    function setUp() external {
        asset = IERC20Like(address(new ERC20("Asset", "ASSET", 18)));

        token = ITokenLike(address(new Basic4626Deposit(address(asset), "Token", "TOKEN", 18)));

        lpHandler = ILpHandlerLike(address(new UnboundedLpHandler(address(asset), address(token), 50)));

        transferHandler = ITransferHandlerLike(address(new UnboundedTransferHandler(address(asset), address(token))));

        excludeContract(address(asset));
        excludeContract(address(token));

        targetSender(address(0x1234));
    }

    function invariant_A() external { assert_invariant_A(); }
    function invariant_B() external { assert_invariant_B(); }
    function invariant_C() external { assert_invariant_C(); }

    function invariant_call_summary() external view {
        console.log("\nCall Summary\n");
        console.log("unboundedLp.addLp         ", lpHandler.numCalls("unboundedLp.addLp"));
        console.log("unboundedLp.deposit       ", lpHandler.numCalls("unboundedLp.deposit"));
        console.log("unboundedLp.transfer      ", lpHandler.numCalls("unboundedLp.transfer"));
        console.log("unboundedTransfer.transfer", transferHandler.numCalls("unboundedTransfer.transfer"));
        console.log("------------------");
        console.log(
            "Sum",
            lpHandler.numCalls("unboundedLp.addLp") +
            lpHandler.numCalls("unboundedLp.deposit") +
            lpHandler.numCalls("unboundedLp.transfer") +
            transferHandler.numCalls("unboundedTransfer.transfer")
        );
    }

}
