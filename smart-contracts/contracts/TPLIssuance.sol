pragma solidity ^0.6.0;

import "@hq20/contracts/contracts/issuance/IssuanceEth.sol";
import "@openzeppelin/contracts/presets/ERC20PresetMinterPauser.sol";

/**
 * @dev The Promised Land Issuance
 */
contract TPLIssuance is IssuanceEth {

    uint256 issueCap;
    uint256 raiseCap;

    event IssueCapSet();

    constructor(
        address _thePromisedLand
    ) public IssuanceEth(_thePromisedLand) {}

    /**
     * @notice Use this function to claim your issuance tokens
     * @dev Each user will call this function on his behalf
     */
    function claim() external override nonReentrant {
        require(
            currentState == "LIVE",
            "Cannot claim now."
        );
        require(
            investments[msg.sender] > 0,
            "No investments found."
        );
        uint256 amount = investments[msg.sender];
        investments[msg.sender] = 0;
        ERC20PresetMinterPauser _issuanceToken = ERC20PresetMinterPauser(
            issuanceToken
        );
        _issuanceToken.mint(
            msg.sender,
            amount.divd(issuePrice, _issuanceToken.decimals())
        );
    }

    function invest() public override payable {
        require(
            currentState == "OPEN",
            "Not open for investments."
        );
        require(
            msg.value.mod(issuePrice) == 0,
            "Fractional investments not allowed."
        );
        require(
            msg.value <= raiseCap - amountRaised,
            "Investment too large."
        );
        if (investments[msg.sender] == 0){
            investors.push(msg.sender);
        }
        investments[msg.sender] = investments[msg.sender].add(msg.value);
        amountRaised = amountRaised.add(msg.value);
        emit InvestmentAdded(msg.sender, msg.value);
    }

    /**
     * @dev Function for an investor to cancel his investment
     */
    function cancelInvestment() external override nonReentrant {
        require (
            currentState == "OPEN" || currentState == "FAILED",
            "Cannot cancel now."
        );
        require(
            investments[msg.sender] > 0,
            "No investments found."
        );
        uint256 amount = investments[msg.sender];
        investments[msg.sender] = 0;
        amountRaised -= amount;
        msg.sender.transfer(amount);
        emit InvestmentCancelled(msg.sender, amount);
    }

    /**
     * @dev Function to open the issuance to investors
     */
    function startIssuance() public override onlyOwner {
        require(
            issuePrice > 0,
            "Issue price not set."
        );
        require(
            issueCap > 0,
            "Issue cap not set."
        );
        raiseCap = issueCap.muld(issuePrice, 18);
        _transition("OPEN");
    }

    function setIssueCap(uint256 _issueCap) public virtual onlyOwner {
        require(
            currentState == "SETUP",
            "Cannot setup now."
        );
        issueCap = _issueCap;
        emit IssueCapSet();
    }
}