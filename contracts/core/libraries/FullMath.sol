// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/// @title Contains 512-bit math functions
/// @notice Facilitates multiplication and division that can have overflow of an intermediate value without any loss of precision
/// @dev Handles "phantom overflow" i.e., allows multiplication and division where an intermediate value overflows 256 bits
library FullMath {
    /// @notice Calculates floor(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
    /// @param a The multiplicand
    /// @param b The multiplier
    /// @param denominator The divisor
    /// @return result The 256-bit result
    function mulDiv(
        uint256 a,
        uint256 b,
        uint256 denominator
    ) internal pure returns (uint256 result) {
        if (denominator == 0) revert("Division by zero");

        uint256 prod0;
        uint256 prod1;
        assembly {
            // 512-bit multiply [prod1 prod0] = a * b
            // Compute the product mod 2^256 and mod 2^256 - 1
            let mm := mulmod(a, b, not(0))
            prod0 := mul(a, b)
            prod1 := sub(sub(mm, prod0), lt(mm, prod0))

            // Handle non-overflow cases, 256 by 256 division
            if iszero(prod1) {
                result := div(prod0, denominator)
            }

            // Make sure the result is less than 2^256.
            // Also prevents denominator == 0
            if gt(prod1, 0) {
                // Make sure the result is less than 2^256 and denominator > prod1
                if iszero(gt(denominator, prod1)) {
                    revert(0, 0)
                }

                ///////////////////////////////////////////////
                // 512 by 256 division.
                ///////////////////////////////////////////////

                // Make division exact by subtracting the remainder from [prod1 prod0].
                // Compute remainder using mulmod.
                // Subtract 256 bit number from 512 bit number.
                let remainder := mulmod(a, b, denominator)
                prod1 := sub(prod1, gt(remainder, prod0))
                prod0 := sub(prod0, remainder)

                // Factor powers of two out of denominator.
                // Compute largest power of two divisor of denominator (always >= 1).
                // Note: this line is equivalent to "denominator & -denominator".
                let twos := and(denominator, sub(0, denominator))

                // Divide denominator by power of two.
                denominator := div(denominator, twos)

                // Divide [prod1 prod0] by the same power of two.
                prod0 := div(prod0, twos)

                // Shift in bits from prod1 into prod0.
                // If twos is 2^k, this is equivalent to dividing by 2^k and then multiplying by 2^256.
                twos := add(div(sub(0, twos), twos), 1)
                prod0 := or(prod0, mul(prod1, twos))

                // Invert denominator mod 2^256.
                // Now that denominator is an odd number, it has an inverse modulo 2^256 such that
                // denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed
                // that is correct for four bits. That is, denominator * inv = 1 mod 2^4
                let inv := mul(3, denominator)
                inv := xor(inv, 2)
                inv := mul(inv, sub(2, mul(denominator, inv))) // inverse mod 2^8
                inv := mul(inv, sub(2, mul(denominator, inv))) // inverse mod 2^16
                inv := mul(inv, sub(2, mul(denominator, inv))) // inverse mod 2^32
                inv := mul(inv, sub(2, mul(denominator, inv))) // inverse mod 2^64
                inv := mul(inv, sub(2, mul(denominator, inv))) // inverse mod 2^128
                inv := mul(inv, sub(2, mul(denominator, inv))) // inverse mod 2^256

                // Because the division is now exact we can divide by multiplying
                // with the modular inverse of the denominator. This will give us the
                // correct result modulo 2^256. Since the precoditions guarantee that
                // the outcome is less than 2^256, this is the final result.
                result := mul(prod0, inv)
            }
        }
    }

    /// @notice Calculates ceil(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
    /// @param a The multiplicand
    /// @param b The multiplier
    /// @param denominator The divisor
    /// @return result The 256-bit result
    function mulDivRoundingUp(uint256 a, uint256 b, uint256 denominator) internal pure returns (uint256 result) {
        result = mulDiv(a, b, denominator);
        if (mulmod(a, b, denominator) > 0) {
            require(result < type(uint256).max);
            result++;
        }
    }
}
