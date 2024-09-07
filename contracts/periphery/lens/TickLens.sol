// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.8.0;

import {TickMath} from "../../core/libraries/TickMath.sol";
import "../../core/interfaces/ICLPool.sol";
import "../interfaces/ITickLens.sol";

/// @title Tick Lens contract
contract TickLens is ITickLens {
    /// @inheritdoc ITickLens
    function getPopulatedTicksInWord(address pool, int16 tickBitmapIndex)
        public
        view
        override
        returns (PopulatedTick[] memory populatedTicks)
    {
        // fetch bitmap
        uint256 bitmap = ICLPool(pool).tickBitmap(tickBitmapIndex);

        // calculate the number of populated ticks
        uint256 numberOfPopulatedTicks;
        for (uint256 i = 0; i < 256; i++) {
            if (bitmap & (1 << i) > 0) numberOfPopulatedTicks++;
        }

        // fetch populated tick data
        int24 tickSpacing = ICLPool(pool).tickSpacing();
        populatedTicks = new PopulatedTick[](numberOfPopulatedTicks);
        for (uint256 i = 0; i < 256; i++) {
            if (bitmap & (1 << i) > 0) {
                int24 populatedTick = ((int24(tickBitmapIndex) << 8) + int24(i)) * tickSpacing;
                (uint128 liquidityGross, int128 liquidityNet,,,,,,,,) = ICLPool(pool).ticks(populatedTick);
                populatedTicks[--numberOfPopulatedTicks] = PopulatedTick({
                    tick: populatedTick,
                    sqrtRatioX96: TickMath.getSqrtRatioAtTick(populatedTick),
                    liquidityNet: liquidityNet,
                    liquidityGross: liquidityGross
                });
            }
        }
    }
}
