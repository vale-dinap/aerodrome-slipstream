pragma solidity >=0.8.0;
pragma abicoder v2;

import {CLGaugeFactoryTest} from "./CLGaugeFactory.t.sol";
import {CLGauge} from "contracts/gauge/CLGauge.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

contract CreateGaugeTest is CLGaugeFactoryTest {
    address public pool;
    address public feesVotingReward;

    function setUp() public override {
        super.setUp();

        vm.startPrank({msgSender: address(voter)});
    }

    function test_RevertIf_NotVoter() public {
        pool = poolFactory.createPool({
            tokenA: TEST_TOKEN_0,
            tokenB: TEST_TOKEN_1,
            tickSpacing: TICK_SPACING_LOW,
            sqrtPriceX96: encodePriceSqrt(1, 1)
        });
        vm.expectRevert(abi.encodePacked("NV"));
        vm.startPrank(users.charlie);
        CLGauge(
            payable(gaugeFactory.createGauge(forwarder, pool, address(feesVotingReward), address(rewardToken), true))
        );
    }

    function test_CreateGauge() public {
        pool = poolFactory.createPool({
            tokenA: TEST_TOKEN_0,
            tokenB: TEST_TOKEN_1,
            tickSpacing: TICK_SPACING_LOW,
            sqrtPriceX96: encodePriceSqrt(1, 1)
        });
        CLGauge gauge = CLGauge(payable(voter.createGauge({_poolFactory: address(poolFactory), _pool: address(pool)})));
        feesVotingReward = voter.gaugeToFees(address(gauge));

        assertEq(address(gauge.voter()), address(voter));
        assertEq(gauge.feesVotingReward(), address(feesVotingReward));
        assertEq(gauge.rewardToken(), address(rewardToken));
        assertEq(address(gauge.gaugeFactory()), address(gaugeFactory));
        assertFalse(gauge.supportsPayable());
        assertEq(gauge.isPool(), true);
    }

    function test_CreateGauge_WithPayableSupport() public {
        pool = poolFactory.createPool({
            tokenA: TEST_TOKEN_0,
            tokenB: nft.WETH9(),
            tickSpacing: TICK_SPACING_LOW,
            sqrtPriceX96: encodePriceSqrt(1, 1)
        });
        CLGauge gauge = CLGauge(payable(voter.createGauge({_poolFactory: address(poolFactory), _pool: address(pool)})));
        feesVotingReward = voter.gaugeToFees(address(gauge));

        assertEq(address(gauge.voter()), address(voter));
        assertEq(gauge.feesVotingReward(), address(feesVotingReward));
        assertEq(gauge.rewardToken(), address(rewardToken));
        assertEq(address(gauge.gaugeFactory()), address(gaugeFactory));
        assertTrue(gauge.supportsPayable());
        assertEq(gauge.isPool(), true);
    }
}
