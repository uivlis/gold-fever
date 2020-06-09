pragma solidity ^0.6.0;

import "@openzeppelin/contracts/presets/ERC20PresetMinterPauser.sol";


/**
 * @dev Gold Fever - The Promised Land
 */
contract ThePromisedLand is ERC20PresetMinterPauser {
    constructor() public ERC20PresetMinterPauser("The Promised Land", "TPL") {}
}