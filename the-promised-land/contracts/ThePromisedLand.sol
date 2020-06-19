pragma solidity 0.5.7;

import "@openzeppelin2/contracts/token/ERC20/ERC20Pausable.sol";
import "@openzeppelin2/contracts/token/ERC20/ERC20Mintable.sol";
import "@openzeppelin2/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin2/contracts/token/ERC20/ERC20Detailed.sol";


/**
 * @dev Gold Fever - The Promised Land
 */
contract ThePromisedLand is ERC20Pausable, ERC20Mintable, ERC20Burnable, ERC20Detailed {
    constructor() public ERC20Detailed("The Promised Land", "TPL", 18) {}
}