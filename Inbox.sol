
// SPDX-License-Identifier: RYT

pragma solidity ^0.6.0;

import "./AggregatorV3Interface.sol";
import "./SafeMath.sol";

contract Inbox {
    
    using SafeMath for uint256;
    
    string public message;
    
    uint256 internal one8 = uint256(100000000);
    AggregatorV3Interface internal priceFeed_ETH_USD;
    AggregatorV3Interface internal priceFeed_CHF_USD;
   
   
    constructor (string memory initialMessage) public {
        message = initialMessage;
        // Kovan
        // priceFeed_ETH_USD = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
        // priceFeed_CHF_USD = AggregatorV3Interface(0xed0616BeF04D374969f302a34AE4A63882490A8C);
        
        // Rinkeby
        // priceFeed_ETH_USD = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        // priceFeed_CHF_USD = AggregatorV3Interface(0x5e601CF5EF284Bcd12decBDa189479413284E1d2);
        
    }
    
    function setMessage(string memory newMessage) public {
        message = newMessage;
    }
    
    function getMessage()  public view returns (string memory ) {
        return message;
    }
    
    
     /**
     * Returns the latest price ETH/CHF
     */
    function getPrice_ETH_CHF() public view returns (uint256) {
        return (getPrice_ETH_USD().mul(one8)).div(getPrice_CHF_USD());
    }
    
    /**
     * Returns the latest price ETH/USD
     */
    function getPrice_ETH_USD() public view returns (uint256) {
        /* (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed_ETH_USD.latestRoundData();
        return uint256(price); */
        return uint256(130729724375);
    }
    
     /**
     * Returns the latest price CHF/USD
     */
    function getPrice_CHF_USD() public view returns (uint256) {
        /* (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed_CHF_USD.latestRoundData();
        return uint256(price); */
        return uint256(112275110);
    }
    
   
    
}
