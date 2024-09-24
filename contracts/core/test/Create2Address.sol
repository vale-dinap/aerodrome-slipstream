// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import {Clones} from "../../../lib/openzeppelin-contracts/contracts/proxy/Clones.sol";

// Used to predict the address of a CL pool
contract Create2Address {
    function predictDeterministicAddress(address factory, bytes32 salt, address deployer)
        external
        pure
        returns (address)
    {
        return Clones.predictDeterministicAddress(factory, salt, deployer);
    }
}
