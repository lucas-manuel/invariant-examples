// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import { console } from "../lib/forge-std/src/console.sol";

import { Basic4626Deposit } from "../src/Basic4626Deposit.sol";

import { ERC20 }            from "./ERC20.sol";
import { InvariantTest }    from "./InvariantTest.sol";
import { BoundedLpHandler } from "./LpHandler.sol";
// import { Warper }           from "./Warper.sol";

contract BoundedPattern is InvariantTest {

    Basic4626Deposit public token;

    ERC20 public asset;

    BoundedLpHandler public lpHandler;

    // Warper public warper;

    uint256 public currentTimestamp;

    // modifier useCurrentTimestamp {
    //     vm.warp(currentTimestamp);
    //     _;
    // }

    // function setCurrentTimestamp(uint256 currentTimestamp_) external {
    //     currentTimestamp = currentTimestamp_;
    // }

    function setUp() external {
        asset = new ERC20("Asset", "ASSET", 18);

        token = new Basic4626Deposit(address(asset), "Token", "TOKEN", 18);

        lpHandler = new BoundedLpHandler(address(asset), address(token), 50);
        // warper    = new Warper();

        excludeContract(address(asset));
        excludeContract(address(token));

        targetSender(address(0x1234));
    }

    function invariant_A() public {
        assertGe(token.totalAssets(), token.totalSupply());
    }

    function invariant_B() public {
        assertEq(token.totalAssets(), asset.balanceOf(address(token)));
    }

    function invariant_C() public {
        assertEq(lpHandler.sumBalance(), token.totalSupply());
    }

    function invariant_D_E_F() public {
        uint256 sumAssets;

        uint256 numLps      = lpHandler.numLps();
        uint256 totalAssets = token.totalAssets();
        uint256 totalSupply = token.totalSupply();

        if (totalAssets == 0 || totalSupply == 0) return;

        for (uint256 i = 0; i < numLps; i++) {
            address lp = lpHandler.lps(i);

            uint256 assetBalance = token.convertToAssets(token.balanceOf(lp));

            assertGe(assetBalance, token.balanceOf(lp));

            sumAssets += assetBalance;
        }

        assertTrue((token.totalAssets() - sumAssets) <= numLps);
    }

    function invariant_call_summary() public view {
        console.log("\nCall Summary\n");
        console.log("boundedLp.addLp   ", lpHandler.numCalls("boundedLp.addLp"));
        console.log("boundedLp.deposit ", lpHandler.numCalls("boundedLp.deposit"));
        console.log("boundedLp.transfer", lpHandler.numCalls("boundedLp.transfer"));
        // console.log("warper.warp       ", warper.numCalls("warper.warp"));
        console.log("------------------");
        console.log(
            "Sum",
            lpHandler.numCalls("boundedLp.addLp") +
            lpHandler.numCalls("boundedLp.deposit") +
            lpHandler.numCalls("boundedLp.transfer")
            // warper.numCalls("warper.warp")
        );
    }

}
