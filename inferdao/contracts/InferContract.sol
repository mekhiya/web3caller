// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract InferContract is Ownable {
    IERC20 public inferToken;
    AggregatorV3Interface internal priceFeed;
    address[] public sponsors;
    address[] public clients;

    constructor(address _inferTokenAddress) public {
        inferToken = IERC20(_inferTokenAddress);
    }

    // constructor(address AggregatorAddress) {
    //     priceFeed = AggregatorV3Interface(AggregatorAddress);
    // }

    /// anyone who wants to become client & get sponsorship,
    /// has to accept infr, because we will disperse funds in infr coins.
    // ApproveSponsor onlyOwner
    // addAllowedTokensFromSponsors onlyOwner
    // ApproveClient onlyOwner
    // makeMeSponsor
    // makeMeClient
    // disPatchFundsToClient onlyOwner
    // issueINFRToClient onlyOwner
    // issueINFRToSponsor onlyOwner

    function makeMeSponsor(address sponsorAddress, uint256 amount)
        public
        returns (uint256)
    {
        uint256 amountInUSD = amount;
        require(amountInUSD > 10, "Minimum 10 dollars to become sponsor");
        sponsors.push(sponsorAddress);
        // reward INFR coin
        //
        //return uint256(1);
        return 1;
    }

    function getLatestPrice() public view returns (int256) {
        (
            uint80 roundID,
            int256 price,
            uint256 startedAt,
            uint256 timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }
}
