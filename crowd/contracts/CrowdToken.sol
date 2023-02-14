// SPDX-License-Identifier: UNLICENCED
pragma solidity 0.8.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CrowdToken is ERC20 {
    constructor() ERC20("CrowdToken", "MVK") {
        _mint(msg.sender, 1000 * 10 ** decimals());
    }
}

