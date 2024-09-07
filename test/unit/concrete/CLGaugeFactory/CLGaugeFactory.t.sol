pragma solidity >=0.8.0;
pragma abicoder v2;

import "../../../BaseFixture.sol";

contract CLGaugeFactoryTest is BaseFixture {
    function test_InitialState() public {
        assertEq(gaugeFactory.voter(), address(voter));
        assertEq(gaugeFactory.implementation(), address(gaugeImplementation));
    }
}
