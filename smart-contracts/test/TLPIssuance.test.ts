import { should } from 'chai';
import { ThePromisedLandInstance } from '../types/truffle-contracts';
import { TPLIssuanceInstance } from '../types/truffle-contracts';

const {
    ether,           
    expectRevert,
} = require('@openzeppelin/test-helpers');

const ThePromisedLand: Truffle.Contract<ThePromisedLandInstance> = artifacts.require('./ThePromisedLand.sol');
const TPLIssuance: Truffle.Contract<TPLIssuanceInstance> = artifacts.require('./TPLIssuance.sol');

should();

/** @test {TPLIssuance} contract */
contract('TPLIssuance', (accounts) => {
    /**
     * Test invest
     * @test {TPLIssuance#invest}
     */
    it('...should allow investing if tokens are available', async () => {
        const thePromisedLand = await ThePromisedLand.new();
        const tplIssuance = await TPLIssuance.new(thePromisedLand.address);
        
        // grant minter role to issuance
        await thePromisedLand.grantRole(await thePromisedLand.MINTER_ROLE.call(), tplIssuance.address, { from: accounts[0] });

        // setup issuance
        await tplIssuance.setIssuePrice(ether('0.05'), { from: accounts[0] });
        await tplIssuance.setIssueCap(ether('100'), { from: accounts[0] });

        // start the issuance
        await tplIssuance.startIssuance({ from: accounts[0] });

        // Should be able to invest
        await tplIssuance.invest.sendTransaction({ value: ether('5').toString(), from: accounts[1] });

        // Should not be able to invest, since issue cap is reached
        await expectRevert(
            tplIssuance.invest.sendTransaction({ value: ether('1').toString(), from: accounts[2] }),
            "Investment too large."
        );

        // start the distribution phase
        await tplIssuance.startDistribution();
        
        // claim tokens
        await tplIssuance.claim({ from: accounts[1] });

        // check investor's balance
        (await thePromisedLand.balanceOf(accounts[1])).toString().should.be.equal(ether('100').toString());

    });
});
