// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.10;

// import { console } from "../lib/forge-std/src/console.sol";

// import { StdUtils } from "../lib/forge-std/src/StdUtils.sol";
// import { Vm }       from "../lib/forge-std/src/Vm.sol";

// import { Basic4626Deposit } from "../src/Basic4626Deposit.sol";

// import { ERC20 } from "./ERC20.sol";

// contract UnboundedLpHandler is StdUtils {

//     address public currentLp;

//     uint256 public numLps;
//     uint256 public maxLps;

//     address[] public lps;

//     mapping(address => bool) public isLp;

//     mapping(bytes32 => uint256) public numCalls;

//     Basic4626Deposit public token;

//     ERC20 public asset;

//     Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

//     uint256 public sumBalance;

//     modifier useRandomLp(uint256 lpIndex) {
//         currentLp = lps[bound(lpIndex, 0, lps.length - 1)];

//         vm.startPrank(currentLp);
//         _;
//         vm.stopPrank();
//     }

//     constructor(address asset_, address token_, uint256 maxLps_) {
//         asset = ERC20(asset_);
//         token = Basic4626Deposit(token_);

//         lps.push(address(1));
//         numLps = 1;

//         maxLps = maxLps_;
//     }

//     function addLp(address lp) public virtual {
//         numCalls["lpHandler.addLp"]++;

//         if (lp == address(0) || numLps == maxLps || isLp[lp]) return;

//         lps.push(lp);
//         numLps++;

//         isLp[lp] = true;  // Prevent duplicate LP addresses in array
//     }

//     function deposit(uint256 assets, uint256 lpIndex) useRandomLp(lpIndex) public virtual {
//         asset.mint(currentLp, assets);

//         asset.approve(address(token), assets);

//         uint256 shares = token.deposit(assets, currentLp);

//         sumBalance += shares;

//         numCalls["lpHandler.deposit"]++;
//     }

//     function transferAssetToToken(uint256 assets, uint256 lpIndex) useRandomLp(lpIndex) public virtual {
//         asset.mint(currentLp, assets);
//         asset.transfer(address(token), assets);

//         numCalls["lpHandler.transfer"]++;
//     }

// }

// contract BoundedLpHandler is UnboundedLpHandler {

//     constructor(address asset_, address token_, uint256 maxLps_) UnboundedLpHandler(asset_, token_, maxLps_) { }

//     function deposit(uint256 assets, uint256 lpIndex) public override {
//         uint256 totalSupply = token.totalSupply();

//         uint256 minDeposit = totalSupply == 0 ? 1 : token.totalAssets() / totalSupply + 1;

//         assets = bound(assets, minDeposit, 1e36);

//         super.deposit(assets, lpIndex);
//     }

//     function transferAssetToToken(uint256 assets, uint256 lpIndex) public override {
//         assets = bound(assets, 1, 1e27);

//         super.transferAssetToToken(assets, lpIndex);
//     }

// }
