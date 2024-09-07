// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.5.0;

interface IMinter {
    /// @notice Processes emissions and rebases. Callable once per epoch (1 week).
    /// @return _period Start of current epoch.
    function updatePeriod() external returns (uint256 _period);
}
