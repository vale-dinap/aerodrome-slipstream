// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.8.0;

import "./NFTSVGArt.sol";
import "./NFTSVGText.sol";

/// @title NFTSVG
/// @notice Provides a function for generating an SVG associated with a CL NFT
library NFTSVG {
    using Strings for uint256;
    using NFTSVGText for GenerateSVGParams;

    function generateSVG(
        GenerateSVGParams memory params
    ) internal pure returns (bytes memory) {
        return abi.encodePacked(
            '<svg width="800" height="800" viewBox="0 0 800 800" fill="none" xmlns="http://www.w3.org/2000/svg">',
            '<g id="NFT Aero" clip-path="url(#clip0_1098_820)">',
            '<rect width="800" height="800" fill="#252525"/>',
            '<g id="shadow">',
            '<g id="Group 465">',
            '<path id="Rectangle 173" d="M394 234L394 566L-0.000117372 566L-0.00012207 234L394 234Z" fill="url(#paint0_linear_1098_820)"/>',
            '</g>',
            '</g>',
            params.generateTopText(),
            NFTSVGArt.generateArt(),
            params.generateBottomText(),
            NFTSVGArt.generateSVGDefs(),
            '</svg>'
        );
    }
}
