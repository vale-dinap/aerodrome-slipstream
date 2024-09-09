# Aerodrome Finance Slipstream – Compatibility Layer

## Overview
This repository contains a fork of the [Aerodrome Slipstream](https://github.com/aerodrome-finance/slipstream) protocol, designed to ensure compatibility with the latest Solidity versions. The primary focus of this fork is to facilitate interaction and integration testing with external smart contracts, while avoiding any modifications to the core logic of Aerodrome, aside from necessary adjustments for Solidity compiler compatibility.

## Purpose
This compatibility layer has been created with two goals in mind:
- **Ensure Compatibility**: Update the Aerodrome Slipstream contracts to work seamlessly with Solidity 0.8.x and newer versions, ensuring that external projects do not face version incompatibility issues.
- **Enable Testing**: Provide an environment where developers can test their smart contracts against the Aerodrome Slipstream protocol, using modern Solidity tooling, without needing to modify the protocol's fundamental behavior.

## What’s Included
The repository includes:
- All the smart contracts and libraries originally included in Aerodrome Slipstream, organized into core, gauge, periphery, and library components.
- Updates for compatibility with Solidity 0.8.x and above.
- Optimized stack usage to prevent errors at compile time. This required substantial refactoring of some parts of the codebase and outright rewriting of certain functions using inline assembly.
- Minor gas optimizations.
- Updated submodules (e.g., OpenZeppelin 3.x -> 4.x) or rebuilt components to ensure compatibility with Solidity 0.8.x.
- Ensured imports use relative paths.

## Key Components
- **Core**: Contains the central contracts like CLFactory.sol and CLPool.sol, along with supporting libraries and interfaces.
- **Gauge**: Implements the gauge system with CLGauge.sol and CLGaugeFactory.sol.
- **Periphery**: Houses auxiliary contracts such as NonfungiblePositionManager.sol and SwapRouter.sol.
- **Libraries**: Includes utility libraries like EnumerableSet.sol and ProtocolTimeLibrary.sol.

## What’s Not Changed
To maintain the integrity of the original protocol:
- No changes have been made to the core logic or functionality of Aerodrome Slipstream, except for those required to ensure compatibility with newer Solidity compiler versions and prevent compiler errors.
- The operational and fee structures remain the same as in the original Aerodrome Slipstream.

## Directory Structure
A high-level overview of the project structure (Solidity files only):

🔷 Blue diamond: Contracts and libraries

🔶 Orange diamond: Interfaces
```bash
📦contracts
┣ 📂core
┃ ┣ 📂fees
┃ ┃ ┣ 🔷CustomSwapFeeModule.sol
┃ ┃ ┗ 🔷CustomUnstakedFeeModule.sol
┃ ┣ 📂interfaces
┃ ┃ ┣ 📂callback
┃ ┃ ┃ ┣ 🔶ICLFlashCallback.sol
┃ ┃ ┃ ┣ 🔶ICLMintCallback.sol
┃ ┃ ┃ ┗ 🔶ICLSwapCallback.sol
┃ ┃ ┣ 📂fees
┃ ┃ ┃ ┣ 🔶ICustomFeeModule.sol
┃ ┃ ┃ ┗ 🔶IFeeModule.sol
┃ ┃ ┣ 📂pool
┃ ┃ ┃ ┣ 🔶ICLPoolActions.sol
┃ ┃ ┃ ┣ 🔶ICLPoolConstants.sol
┃ ┃ ┃ ┣ 🔶ICLPoolDerivedState.sol
┃ ┃ ┃ ┣ 🔶ICLPoolEvents.sol
┃ ┃ ┃ ┣ 🔶ICLPoolOwnerActions.sol
┃ ┃ ┃ ┗ 🔶ICLPoolState.sol
┃ ┃ ┣ 🔶ICLFactory.sol
┃ ┃ ┣ 🔶ICLPool.sol
┃ ┃ ┣ 🔶IERC20Minimal.sol
┃ ┃ ┣ 🔶IFactoryRegistry.sol
┃ ┃ ┣ 🔶IMinter.sol
┃ ┃ ┣ 🔶IPool.sol
┃ ┃ ┣ 🔶IPoolFactory.sol
┃ ┃ ┣ 🔶IVoter.sol
┃ ┃ ┗ 🔶IVotingEscrow.sol
┃ ┣ 📂libraries
┃ ┃ ┣ 🔷BitMath.sol
┃ ┃ ┣ 🔷FixedPoint128.sol
┃ ┃ ┣ 🔷FixedPoint96.sol
┃ ┃ ┣ 🔷FullMath.sol
┃ ┃ ┣ 🔷LiquidityMath.sol
┃ ┃ ┣ 🔷LowGasSafeMath.sol
┃ ┃ ┣ 🔷Oracle.sol
┃ ┃ ┣ 🔷Position.sol
┃ ┃ ┣ 🔷SafeCast.sol
┃ ┃ ┣ 🔷SqrtPriceMath.sol
┃ ┃ ┣ 🔷SwapMath.sol
┃ ┃ ┣ 🔷Tick.sol
┃ ┃ ┣ 🔷TickBitmap.sol
┃ ┃ ┣ 🔷TickMath.sol
┃ ┃ ┣ 🔷TransferHelper.sol
┃ ┃ ┗ 🔷UnsafeMath.sol
┃ ┣ 📂test
┃ ┃ ┣ 🔷BitMathEchidnaTest.sol
┃ ┃ ┣ 🔷BitMathTest.sol
┃ ┃ ┣ 🔷CLPoolSwapTest.sol
┃ ┃ ┣ 🔷CoreTestERC20.sol
┃ ┃ ┣ 🔷Create2Address.sol
┃ ┃ ┣ 🔷FullMathEchidnaTest.sol
┃ ┃ ┣ 🔷FullMathTest.sol
┃ ┃ ┣ 🔷LiquidityMathTest.sol
┃ ┃ ┣ 🔷LowGasSafeMathEchidnaTest.sol
┃ ┃ ┣ 🔷MockTimeCLPool.sol
┃ ┃ ┣ 🔷OracleEchidnaTest.sol
┃ ┃ ┣ 🔷OracleTest.sol
┃ ┃ ┣ 🔷SqrtPriceMathEchidnaTest.sol
┃ ┃ ┣ 🔷SqrtPriceMathTest.sol
┃ ┃ ┣ 🔷SwapMathEchidnaTest.sol
┃ ┃ ┣ 🔷SwapMathTest.sol
┃ ┃ ┣ 🔷TestCLCallee.sol
┃ ┃ ┣ 🔷TestCLReentrantCallee.sol
┃ ┃ ┣ 🔷TestCLRouter.sol
┃ ┃ ┣ 🔷TestCLSwapPay.sol
┃ ┃ ┣ 🔷TickBitmapEchidnaTest.sol
┃ ┃ ┣ 🔷TickBitmapTest.sol
┃ ┃ ┣ 🔷TickEchidnaTest.sol
┃ ┃ ┣ 🔷TickMathEchidnaTest.sol
┃ ┃ ┣ 🔷TickMathTest.sol
┃ ┃ ┣ 🔷TickOverflowSafetyEchidnaTest.sol
┃ ┃ ┣ 🔷TickTest.sol
┃ ┃ ┗ 🔷UnsafeMathEchidnaTest.sol
┃ ┣ 🔷CLFactory.sol
┃ ┗ 🔷CLPool.sol
┣ 📂gauge
┃ ┣ 📂interfaces
┃ ┃ ┣ 🔶ICLGauge.sol
┃ ┃ ┣ 🔶ICLGaugeFactory.sol
┃ ┃ ┗ 🔶IReward.sol
┃ ┣ 📂libraries
┃ ┃ ┗ 🔷SafeCast.sol
┃ ┣ 🔷CLGauge.sol
┃ ┗ 🔷CLGaugeFactory.sol
┣ 📂libraries
┃ ┣ 🔷EnumerableSet.sol
┃ ┗ 🔷ProtocolTimeLibrary.sol
┣ 📂periphery
┃ ┣ 📂base
┃ ┃ ┣ 🔷BlockTimestamp.sol
┃ ┃ ┣ 🔷ERC721Permit.sol
┃ ┃ ┣ 🔷LiquidityManagement.sol
┃ ┃ ┣ 🔷Multicall.sol
┃ ┃ ┣ 🔷PeripheryImmutableState.sol
┃ ┃ ┣ 🔷PeripheryPayments.sol
┃ ┃ ┣ 🔷PeripheryPaymentsWithFee.sol
┃ ┃ ┣ 🔷PeripheryValidation.sol
┃ ┃ ┗ 🔷SelfPermit.sol
┃ ┣ 📂examples
┃ ┃ ┗ 🔷PairFlash.sol
┃ ┣ 📂interfaces
┃ ┃ ┣ 📂external
┃ ┃ ┃ ┣ 🔶IERC1271.sol
┃ ┃ ┃ ┣ 🔶IERC20PermitAllowed.sol
┃ ┃ ┃ ┗ 🔶IWETH9.sol
┃ ┃ ┣ 🔶IERC20Metadata.sol
┃ ┃ ┣ 🔶IERC4906.sol
┃ ┃ ┣ 🔶IERC721Permit.sol
┃ ┃ ┣ 🔶IMixedRouteQuoterV1.sol
┃ ┃ ┣ 🔶IMulticall.sol
┃ ┃ ┣ 🔶INonfungiblePositionManager.sol
┃ ┃ ┣ 🔶INonfungibleTokenPositionDescriptor.sol
┃ ┃ ┣ 🔶IPeripheryImmutableState.sol
┃ ┃ ┣ 🔶IPeripheryPayments.sol
┃ ┃ ┣ 🔶IPeripheryPaymentsWithFee.sol
┃ ┃ ┣ 🔶IQuoter.sol
┃ ┃ ┣ 🔶IQuoterV2.sol
┃ ┃ ┣ 🔶ISelfPermit.sol
┃ ┃ ┣ 🔶ISugarHelper.sol
┃ ┃ ┣ 🔶ISwapRouter.sol
┃ ┃ ┗ 🔶ITickLens.sol
┃ ┣ 📂lens
┃ ┃ ┣ 🔷CLInterfaceMulticall.sol
┃ ┃ ┣ 🔷MixedRouteQuoterV1.sol
┃ ┃ ┣ 🔷Quoter.sol
┃ ┃ ┣ 🔷QuoterV2.sol
┃ ┃ ┗ 🔷TickLens.sol
┃ ┣ 📂libraries
┃ ┃ ┣ 🔷BytesLib.sol
┃ ┃ ┣ 🔷CallbackValidation.sol
┃ ┃ ┣ 🔷ChainId.sol
┃ ┃ ┣ 🔷HexStrings.sol
┃ ┃ ┣ 🔷LiquidityAmounts.sol
┃ ┃ ┣ 🔷NFTDescriptor.sol
┃ ┃ ┣ 🔷NFTSVG.sol
┃ ┃ ┣ 🔷NFTSVGArt.sol
┃ ┃ ┣ 🔷NFTSVGStructs.sol
┃ ┃ ┣ 🔷NFTSVGText.sol
┃ ┃ ┣ 🔷OracleLibrary.sol
┃ ┃ ┣ 🔷Path.sol
┃ ┃ ┣ 🔷PoolAddress.sol
┃ ┃ ┣ 🔷PoolTicksCounter.sol
┃ ┃ ┣ 🔷PositionKey.sol
┃ ┃ ┣ 🔷PositionValue.sol
┃ ┃ ┣ 🔷SqrtPriceMathPartial.sol
┃ ┃ ┣ 🔷TokenRatioSortOrder.sol
┃ ┃ ┗ 🔷TransferHelper.sol
┃ ┣ 📂test
┃ ┃ ┣ 🔷Base64Test.sol
┃ ┃ ┣ 🔷LiquidityAmountsTest.sol
┃ ┃ ┣ 🔷MockObservable.sol
┃ ┃ ┣ 🔷MockObservations.sol
┃ ┃ ┣ 🔷MockTimeNonfungiblePositionManager.sol
┃ ┃ ┣ 🔷MockTimeSwapRouter.sol
┃ ┃ ┣ 🔷NFTDescriptorTest.sol
┃ ┃ ┣ 🔷NFTManagerCallee.sol
┃ ┃ ┣ 🔷NonfungiblePositionManagerPositionsGasTest.sol
┃ ┃ ┣ 🔷OracleLibraryTest.sol
┃ ┃ ┣ 🔷PathTest.sol
┃ ┃ ┣ 🔷PeripheryImmutableStateTest.sol
┃ ┃ ┣ 🔷PoolTicksCounterTest.sol
┃ ┃ ┣ 🔷PositionValueTest.sol
┃ ┃ ┣ 🔷SelfPermitTest.sol
┃ ┃ ┣ 🔷TestCallbackValidation.sol
┃ ┃ ┣ 🔷TestERC20.sol
┃ ┃ ┣ 🔷TestERC20Metadata.sol
┃ ┃ ┣ 🔷TestERC20PermitAllowed.sol
┃ ┃ ┣ 🔷TestMulticall.sol
┃ ┃ ┣ 🔷TestPositionNFTOwner.sol
┃ ┃ ┗ 🔷TickLensTest.sol
┃ ┣ 🔷NonfungiblePositionManager.sol
┃ ┣ 🔷NonfungibleTokenPositionDescriptor.sol
┃ ┣ 🔷SugarHelper.sol
┃ ┗ 🔷SwapRouter.sol
┣ 📂solidity-lib
┃ ┗ 📂libraries
┃   ┣ 🔷AddressStringUtil.sol
┃   ┣ 🔷Babylonian.sol
┃   ┣ 🔷BitMath.sol
┃   ┣ 🔷FixedPoint.sol
┃   ┣ 🔷FullMath.sol
┃   ┣ 🔷SafeERC20Namer.sol
┃   ┗ 🔷TransferHelper.sol
┣ 📂test
┃ ┣ 📂interfaces
┃ ┃ ┗ 🔶IVotingRewardsFactory.sol
┃ ┣ 🔷MockBribeVotingReward.sol
┃ ┣ 🔷MockFactoryRegistry.sol
┃ ┣ 🔷MockFeesVotingReward.sol
┃ ┣ 🔷MockVoter.sol
┃ ┣ 🔷MockVotingEscrow.sol
┃ ┣ 🔷MockVotingRewardsFactory.sol
┗ ┗ 🔷MockWETH.sol
```

## Installation
To use this compatibility layer for testing or integrating external projects:

### 1. Clone the Repository:
```bash
git clone https://github.com/vale-dinap/aerodrome-slipstream.git
```

### 2. Install Dependencies:
Make sure you have installed the necessary dependencies by running:
```bash
yarn install
```

### 3. Compile Contracts:
Ensure the Solidity compiler version is compatible with the updated contracts:
```bash
forge build
```

### 4. Run Tests:
Test the contracts using Foundry or your preferred testing framework:
```bash
forge test
```

## Contributing
Contributions are welcome, especially those that improve compatibility or testing capabilities. Please open an issue or a pull request if you encounter bugs or have suggestions for improvements.

## License
This project is licensed under the same terms as the original Aerodrome Slipstream. All rights to the original Aerodrome Slipstream code remain with [Aerodrome Finance](https://aerodrome.finance/).