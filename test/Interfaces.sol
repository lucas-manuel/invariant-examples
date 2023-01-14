// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

interface ILpHandlerLike {

    function lps(uint256 i) external view returns (address);

    function numCalls(bytes32 name) external view returns (uint256);

    function numLps() external view returns (uint256);

    function sumBalance() external view returns (uint256);

}

interface ITransferHandlerLike {

    function numCalls(bytes32 name) external view returns (uint256);

}
