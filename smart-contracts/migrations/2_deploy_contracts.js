const ThePromisedLand = artifacts.require('./NGL.sol');
const TPLIssuance = artifacts.require('./NGLIssuance.sol');
require('dotenv').config();

module.exports = async (deployer, network, accounts) => {
    await deployer.deploy(NGL, process.env.NGL_MIGRATE_URI);
    // await deployer.deploy(TPLIssuance, ThePromisedLand.address);
}
