// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.8.0;

import "../core/interfaces/ICLPool.sol";
import "@uniswap/contracts/libraries/SafeERC20Namer.sol";
import "base64-sol/base64.sol";

import "./libraries/ChainId.sol";
import "./interfaces/INonfungiblePositionManager.sol";
import "./interfaces/INonfungibleTokenPositionDescriptor.sol";
import "./interfaces/IERC20Metadata.sol";
import "./libraries/PoolAddress.sol";
import "./libraries/NFTDescriptor.sol";
import "./libraries/TokenRatioSortOrder.sol";
import "./libraries/NFTSVG.sol";

/// @title Describes NFT token positions
/// @notice Produces a string containing the data URI for a JSON metadata string
contract NonfungibleTokenPositionDescriptor is INonfungibleTokenPositionDescriptor {

    using Base64 for bytes;

    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address private constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address private constant TBTC = 0x8dAEBADE922dF735c38C80C7eBD708Af50815fAa;
    address private constant WBTC = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;

    address public immutable WETH9;
    /// @dev A null-terminated string
    bytes32 public immutable nativeCurrencyLabelBytes;

    constructor(address _WETH9, bytes32 _nativeCurrencyLabelBytes) {
        WETH9 = _WETH9;
        nativeCurrencyLabelBytes = _nativeCurrencyLabelBytes;
    }

    /// @notice Returns the native currency label as a string
    function nativeCurrencyLabel() internal view returns (string memory) {
        uint256 len;
        while (len < 32 && nativeCurrencyLabelBytes[len] != 0) {
            ++len;
        }
        bytes memory b = new bytes(len);
        for (uint256 i; i < len;) {
            b[i] = nativeCurrencyLabelBytes[i];
            unchecked { ++i; }
        }
        return string(b);
    }

    struct URIbuffer {
        address token0;
        address token1;
        int24 tickSpacing;
        int24 tickLower;
        int24 tickUpper;
        bool _flipRatio;
    }

    /// @inheritdoc INonfungibleTokenPositionDescriptor
    function tokenURI(INonfungiblePositionManager positionManager, uint256 tokenId)
        external
        view
        override
        returns (string memory)
    {
        URIbuffer memory b;
        (,, b.token0, b.token1, b.tickSpacing, b.tickLower, b.tickUpper,,,,,) =
            positionManager.positions(tokenId);

        ICLPool pool = ICLPool(
            PoolAddress.computeAddress(
                positionManager.factory(),
                PoolAddress.PoolKey({token0: b.token0, token1: b.token1, tickSpacing: b.tickSpacing})
            )
        );

        b._flipRatio = flipRatio(b.token0, b.token1, ChainId.get());
        if (b._flipRatio) (b.token0, b.token1) = (b.token1, b.token0);
        NFTDescriptor.ConstructTokenURIParams memory params = NFTDescriptor.ConstructTokenURIParams({
            tokenId: tokenId,
            quoteTokenAddress: b.token1,
            baseTokenAddress: b.token0,
            quoteTokenSymbol: b.token1 == WETH9
                ? nativeCurrencyLabel()
                : SafeERC20Namer.tokenSymbol(b.token1),
            baseTokenSymbol: b.token0 == WETH9
                ? nativeCurrencyLabel()
                : SafeERC20Namer.tokenSymbol(b.token0),
            quoteTokenDecimals: IERC20Metadata(b.token1).decimals(),
            baseTokenDecimals: IERC20Metadata(b.token0).decimals(),
            flipRatio: b._flipRatio,
            tickLower: b.tickLower,
            tickUpper: b.tickUpper,
            tickSpacing: b.tickSpacing,
            poolAddress: address(pool)
        });

        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                abi.encodePacked(
                    "{",
                    NFTDescriptor.constructTokenURI(params),
                    ', "image": "data:image/svg+xml;base64,',
                    generateSVG(positionManager, params).encode(),
                    '"}'
                ).encode()
            )
        );
    }

    function generateSVG(
        INonfungiblePositionManager positionManager,
        NFTDescriptor.ConstructTokenURIParams memory params
    ) internal view returns (bytes memory) {
        (uint256 quoteTokensOwed, uint256 baseTokensOwed) =
            tokensOwed({positionManager: positionManager, tokenId: params.tokenId, _flipRatio: params.flipRatio});
        return NFTSVG.generateSVG(
            GenerateSVGParams({
                quoteTokenSymbol: params.quoteTokenSymbol,
                baseTokenSymbol: params.baseTokenSymbol,
                tokenId: params.tokenId,
                tickSpacing: params.tickSpacing,
                quoteTokensOwed: quoteTokensOwed,
                baseTokensOwed: baseTokensOwed,
                tickLower: params.tickLower,
                tickUpper: params.tickUpper,
                quoteTokenDecimals: params.quoteTokenDecimals,
                baseTokenDecimals: params.baseTokenDecimals
            })
        );
    }

    function tokensOwed(INonfungiblePositionManager positionManager, uint256 tokenId, bool _flipRatio)
        internal
        view
        returns (uint256 quoteTokensOwed, uint256 baseTokensOwed)
    {
        (,,,,,,,,,, quoteTokensOwed, baseTokensOwed) = positionManager.positions(tokenId);
        if (_flipRatio) (quoteTokensOwed, baseTokensOwed) = (baseTokensOwed, quoteTokensOwed);
    }

    function flipRatio(address token0, address token1, uint256 chainId) public view returns (bool) {
        return tokenRatioPriority(token0, chainId) > tokenRatioPriority(token1, chainId);
    }

    function tokenRatioPriority(address token, uint256 chainId) public view returns (int256) {
        if (token == WETH9) {
            return TokenRatioSortOrder.DENOMINATOR;
        }
        if (chainId == 1) {
            if (token == USDC) {
                return TokenRatioSortOrder.NUMERATOR_MOST;
            } else if (token == USDT) {
                return TokenRatioSortOrder.NUMERATOR_MORE;
            } else if (token == DAI) {
                return TokenRatioSortOrder.NUMERATOR;
            } else if (token == TBTC) {
                return TokenRatioSortOrder.DENOMINATOR_MORE;
            } else if (token == WBTC) {
                return TokenRatioSortOrder.DENOMINATOR_MOST;
            } else {
                return 0;
            }
        }
        return 0;
    }
}
