// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "./NFTSVGStructs.sol";

/// @title NFTSVG Text
library NFTSVGText {
    using Strings for uint256;

    function generateTopText(
        GenerateSVGParams memory p
    ) internal pure returns (bytes memory) {
        return abi.encodePacked(
            '<g id="',
            generateTopTextPoolId(p), p.tokenId.toString(),
            '"><text fill="#F3F4F6" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="32" font-weight="bold" letter-spacing="0em"><tspan x="56" y="85.5938">',
            generateTopTextPoolId(p),
            '</tspan></text></g><text id="ID #1223" fill="#F3F4F6" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="20" letter-spacing="0em"><tspan x="56" y="128.913">"ID #"',
            p.tokenId.toString(),
            '</tspan></text>'
        );
    }

    function generateBottomText(
        GenerateSVGParams memory p
    ) internal pure returns (bytes memory) {
        return abi.encodePacked(
            generateBottomTextPart1(p),
            generateBottomTextPart2(p)
        );
    }

    function generateTopTextPoolId(
        GenerateSVGParams memory p
    ) private pure returns (bytes memory) {
        return abi.encodePacked(
            "CL",
            tickToString(p.tickSpacing),
            "-",
            p.quoteTokenSymbol,
            "/",
            p.baseTokenSymbol
        );
    }

    function generateBottomTextPart1(
        GenerateSVGParams memory p
    ) private pure returns (bytes memory) {
        return abi.encodePacked(
            '<text id="',
            generateBottomTextBalances(p),
            '" fill="#F3F4F6" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="32" font-weight="bold" letter-spacing="0em"><tspan x="56" y="676.594">',
            generateBottomTextBalances(p),
            '</tspan></text><rect id="line" opacity="0.05" x="56" y="700" width="693" height="2" fill="#D9D9D9"/><text id="'
        );
    }

    function generateBottomTextPart2(
        GenerateSVGParams memory p
    ) private pure returns (bytes memory) {
        return abi.encodePacked(
            tickToString(p.tickLower),
            ' Low &#226;&#128;&#148; ',
            tickToString(p.tickUpper),
            ' High " fill="#F3F4F6" xml:space="preserve" style="white-space: pre" font-family="Arial" font-size="20" letter-spacing="0em"><tspan x="56" y="736.434">',
            tickToString(p.tickLower),
            ' Low &#x2014; ',
            tickToString(p.tickUpper),
            ' High </tspan></text></g>'
        );
    }

    function generateBottomTextBalances(
        GenerateSVGParams memory p
    ) private pure returns (bytes memory) {
        return abi.encodePacked(
            balanceToDecimals(p.quoteTokensOwed, p.quoteTokenDecimals),
            " ",
            p.quoteTokenSymbol,
            " ~ ",
            balanceToDecimals(p.baseTokensOwed, p.baseTokenDecimals),
            " ",
            p.baseTokenSymbol
        );
    }

    function balanceToDecimals(uint256 _balance, uint8 decimals) private pure returns (bytes memory) {
        uint256 integerPart;
        uint256 fractionalPart;
        bytes32 leadingZeros = "";
        {
            uint256 zerosToAdd;

            assembly {
                // Compute divisor = 10 ** decimals
                let divisor := exp(10, decimals)
                // Compute integerPart = balance / divisor
                integerPart := div(_balance, divisor)
                // Compute fractionalPart = balance % divisor
                fractionalPart := mod(_balance, divisor)

                // Trim to 5 decimal places if needed
                if gt(decimals, 5) {
                    let adjustedDivisor := exp(10, sub(decimals, 5))
                    fractionalPart := div(fractionalPart, adjustedDivisor)
                }

                // Calculate length of fractionalPart
                let tempFractional := fractionalPart
                let fractionalPartLength := 0
                for { } gt(tempFractional, 0) { tempFractional := div(tempFractional, 10) } {
                    fractionalPartLength := add(fractionalPartLength, 1)
                }
                // Handle case when fractionalPart is 0
                if eq(fractionalPartLength, 0) {
                    fractionalPartLength := 1
                }

                // zerosToAdd = max(0, 5 - fractionalPartLength)
                zerosToAdd := sub(5, fractionalPartLength)
                if gt(fractionalPartLength, 5) {
                    zerosToAdd := 0
                }
            }

            // Build leading zeros string
            for (uint256 i; i < zerosToAdd;) {
                leadingZeros = bytes32(abi.encodePacked(leadingZeros, "0"));
                unchecked { ++i; }
            }
        }

        // Return the concatenated string
        return abi.encodePacked(
            integerPart.toString(),
            ".",
            leadingZeros,
            fractionalPart.toString()
        );
    }

    function tickToString(int24 tick) private pure returns (bytes memory) {
        bytes32 sign;
        if (tick < 0) {
            tick *= -1;
            sign = "-";
        }
        return abi.encodePacked(sign, uint256(int256(tick)).toString());
    }
}
