// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import "../../../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";

contract TestERC20 is ERC20Permit {
    constructor(uint256 amountToMint) ERC20("Test ERC20", "TEST") ERC20Permit("Test ERC20") {
        _mint(msg.sender, amountToMint);
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
