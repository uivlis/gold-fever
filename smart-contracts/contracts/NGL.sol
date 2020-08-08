pragma solidity ^0.6.6;

import "@openzeppelin/contracts/presets/ERC1155PresetMinterPauser.sol";


/**
 * @dev Gold Fever - NGL
 */
contract NGL is ERC1155PresetMinterPauser {

    constructor(string memory uri) public ERC1155PresetMinterPauser(uri) { }

}