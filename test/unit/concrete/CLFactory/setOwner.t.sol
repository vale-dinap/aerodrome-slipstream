pragma solidity >=0.8.0;
pragma abicoder v2;

import {CLFactoryTest} from "./CLFactory.t.sol";

contract SetOwnerTest is CLFactoryTest {
    function setUp() public override {
        super.setUp();

        vm.startPrank({msgSender: users.owner});
    }

    function test_RevertIf_NotOwner() public {
        vm.expectRevert();
        vm.startPrank({msgSender: users.charlie});
        poolFactory.setOwner({_owner: users.charlie});
    }

    function test_RevertIf_ZeroAddress() public {
        vm.expectRevert();
        poolFactory.setOwner({_owner: address(0)});
    }

    function test_SetOwner() public {
        vm.expectEmit(true, true, false, false, address(poolFactory));
        emit OwnerChanged({oldOwner: users.owner, newOwner: users.alice});
        poolFactory.setOwner({_owner: users.alice});

        assertEq(poolFactory.owner(), users.alice);
    }
}
