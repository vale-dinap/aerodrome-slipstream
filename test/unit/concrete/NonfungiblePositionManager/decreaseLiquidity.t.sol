pragma solidity >=0.8.0;
pragma abicoder v2;

import {INonfungiblePositionManager} from "contracts/periphery/interfaces/INonfungiblePositionManager.sol";
import "./NonfungiblePositionManager.t.sol";

contract DecreaseLiquidityTest is NonfungiblePositionManagerTest {
    function test_RevertIf_CallerIsNotGauge() public {
        uint256 tokenId = nftCallee.mintNewFullRangePositionForUserWith60TickSpacing(TOKEN_1, TOKEN_1, users.alice);

        nft.approve(address(gauge), tokenId);
        gauge.deposit({tokenId: tokenId});

        vm.expectRevert();
        nft.decreaseLiquidity(
            INonfungiblePositionManager.DecreaseLiquidityParams({
                tokenId: tokenId,
                liquidity: uint128(TOKEN_1),
                amount0Min: 0,
                amount1Min: 0,
                deadline: block.timestamp
            })
        );
    }
}
