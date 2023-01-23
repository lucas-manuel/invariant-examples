// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import { MockERC20 } from "../../lib/erc20/contracts/test/mocks/MockERC20.sol";

import { StdUtils } from "../../lib/forge-std/src/StdUtils.sol";
import { Vm }       from "../../lib/forge-std/src/Vm.sol";

import { Basic4626Deposit } from "../../src/Basic4626Deposit.sol";

contract UnboundedTransferHandler is StdUtils {

    mapping(bytes32 => uint256) public numCalls;

    Basic4626Deposit public token;

    MockERC20 public asset;

    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    uint256 public sumBalance;

    constructor(address asset_, address token_) {
        asset = MockERC20(asset_);
        token = Basic4626Deposit(token_);
    }

    function transferAssetToToken(address owner, uint256 assets) public virtual {
        numCalls["unboundedTransfer.transfer"]++;

        asset.mint(owner, assets);

        vm.prank(owner);
        asset.transfer(address(token), assets);
    }

}

contract BoundedTransferHandler is UnboundedTransferHandler {

    constructor(address asset_, address token_) UnboundedTransferHandler(asset_, token_) { }

    function transferAssetToToken(address owner, uint256 assets) public override {
        numCalls["boundedTransfer.transfer"]++;

        assets = bound(assets, 0, token.totalAssets() / 100);

        super.transferAssetToToken(owner, assets);
    }

}
