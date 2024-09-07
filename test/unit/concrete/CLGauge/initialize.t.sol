pragma solidity >=0.8.0;
pragma abicoder v2;

import {CLGauge} from "contracts/gauge/CLGauge.sol";
import {CLGaugeTest} from "./CLGauge.t.sol";

contract InitializeTest is CLGaugeTest {
    function test_RevertIf_AlreadyInitialized() public {
        address pool = poolFactory.createPool({
            tokenA: TEST_TOKEN_0,
            tokenB: TEST_TOKEN_1,
            tickSpacing: TICK_SPACING_LOW,
            sqrtPriceX96: encodePriceSqrt(1, 1)
        });
        address gauge = voter.createGauge({_poolFactory: address(poolFactory), _pool: address(pool)});
        address feesVotingReward = voter.gaugeToFees(gauge);

        vm.expectRevert(abi.encodePacked("AI"));
        CLGauge(payable(gauge)).initialize({
            _pool: pool,
            _feesVotingReward: feesVotingReward,
            _rewardToken: address(rewardToken),
            _voter: address(voter),
            _nft: address(nft),
            _token0: address(token0),
            _token1: address(token1),
            _tickSpacing: TICK_SPACING_60,
            _isPool: true
        });
    }
}
