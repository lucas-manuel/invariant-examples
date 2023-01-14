// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

interface IERC20Like {

    function balanceOf(address account) external view returns (uint256);

    function totalSupply() external view returns (uint256);

}

interface ITokenLike is IERC20Like {

    function convertToAssets(uint256 amount) external view returns (uint256);

    function totalAssets() external view returns (uint256);

}

interface ILpHandlerLike {

    function lps(uint256 i) external view returns (address);

    function numCalls(bytes32 name) external view returns (uint256);

    function numLps() external view returns (uint256);

    function sumBalance() external view returns (uint256);

}

interface ITransferHandlerLike {

    function numCalls(bytes32 name) external view returns (uint256);

}
