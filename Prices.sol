// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "./AggregatorV3Interface.sol";
import "./SafeMath.sol";

/**
 * @dev Collection of functions related to the address type
 */
library Prices {
    
    using SafeMath for uint256;
    
    function getPrice_CHF_ETH(uint env_) public view returns (uint) {
        uint256  one8 = uint256(100000000);
        return one8.mul(one8).div(getPrice_ETH_CHF(env_));
    }
    
    function getPrice_ETH_CHF(uint env_) public view returns (uint) {
        uint256  one8 = uint256(100000000);
        return getPrice_ETH_USD(env_).mul(one8).div(getPrice_CHF_USD(env_));
    }
    
    
    function getPrice_ETH_USD(uint env_) private view returns (uint) {
        if (env_ == 0) {
            return uint(130729724375);
        } else {
            AggregatorV3Interface priceFeed_ETH_USD;
            if (env_== 1) {
                priceFeed_ETH_USD = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
            } else if (env_== 2){
                priceFeed_ETH_USD = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
            }
             (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
            ) = priceFeed_ETH_USD.latestRoundData();
            return uint(price); 
        }
    }
    
    function getPrice_CHF_USD(uint env_) private view returns (uint) {
        if (env_ == 0) {
            return uint(112275110);
        } else {
            AggregatorV3Interface priceFeed_CHF_USD;
            if (env_== 1) {
                priceFeed_CHF_USD = AggregatorV3Interface(0xed0616BeF04D374969f302a34AE4A63882490A8C);
            } else if (env_== 2){
                priceFeed_CHF_USD = AggregatorV3Interface(0x5e601CF5EF284Bcd12decBDa189479413284E1d2);
            }
             (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
            ) = priceFeed_CHF_USD.latestRoundData();
            return uint(price); 
        }
    }

}
