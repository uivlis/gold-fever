const ThePromisedLand = artifacts.require('./ThePromisedLand.sol');
const TPLIssuance = artifacts.require('./TPLIssuance.sol');

module.exports = async (deployer, network, accounts) => {
    await deployer.deploy(ThePromisedLand);
    // await deployer.deploy(TPLIssuance, ThePromisedLand.address);
}
