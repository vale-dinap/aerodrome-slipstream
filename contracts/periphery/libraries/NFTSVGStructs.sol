// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.8.0;

/// @title NFTSVG Structs

struct GenerateSVGParams {
    string quoteTokenSymbol;
    string baseTokenSymbol;
    uint256 tokenId;
    uint256 quoteTokensOwed;
    uint256 baseTokensOwed;
    int24 tickSpacing;
    int24 tickLower;
    int24 tickUpper;
    uint8 quoteTokenDecimals;
    uint8 baseTokenDecimals;
}