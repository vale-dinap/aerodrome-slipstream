// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.0;

import {IVotingEscrow} from "../core/interfaces/IVotingEscrow.sol";

contract MockVotingEscrow is IVotingEscrow {
    address public immutable override team;

    constructor(address _team) {
        team = _team;
    }

    function createLock(uint256, uint256) external pure override returns (uint256) {
        return 0;
    }
}
