const ThePromisedLand = artifacts.require('./ThePromisedLand.sol');
const TPLIssuance = artifacts.require('./TPLIssuance.sol');
require('dotenv').config();

module.exports = async (deployer, network, accounts) => {
    await deployer.deploy(TPLIssuance, process.env.TPL_ADDRESS);
}
