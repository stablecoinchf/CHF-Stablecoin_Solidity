pragma solidity ^0.6.0;

import "./SafeMath.sol";

contract BondCampaign  {
    
    using SafeMath for uint256;
    
    uint one8 = uint256(100000000);
    
    uint targetPrice  = uint(100).mul(one8);
    
    uint  minPrice = uint(98).mul(one8);
    
    uint startTime;
    
    uint duration = 300;
    
    uint private priceDiscount = 70;
    
    uint public amount;
    
    uint public price;

    
    constructor (uint  price_, uint totalsupply_, uint minPrice_) public {
        _update(price_,totalsupply_, minPrice_);
    }
    
    function restTime()  public view returns (uint) {
        uint resttime = now - startTime;
        if (resttime >= duration) {
            resttime = 0;
        } else {
            resttime = duration - resttime;
        }
        return resttime;
    }
    
    function getCoinBuyPrice(uint _price) public view returns (uint) {
        uint buyPrice = 0;
        if (_price< minPrice) {
            buyPrice = _price.mul(102).div(100);
        }
        if (buyPrice > minPrice) {
            buyPrice = minPrice;
        }
        return buyPrice;
    }
    
    function getAmountOfCoins() public view returns (uint) {
        return amount.mul(getBondPrice()).div(one8).div(100);
    }
    
     function getBondPrice() public view returns (uint) {
        uint bondPrice = 0;
        if (price < minPrice) {
            bondPrice = price.mul(priceDiscount).div(100);
        }
        return bondPrice;
    } 
    
    
    function bondSold(uint amount_) public {
        amount = amount.sub(amount_);
    }
    
    function coinBought(uint amount_) public {
        uint bondreduction = 0;
        if (getBondPrice()>0) {
             bondreduction = amount_.mul(one8).div(getBondPrice()).mul(100);    
        }
        
        amount = amount.sub(bondreduction);
    }
    
     function update(uint  price_, uint totalsupply_, uint minPrice_) public {
         
         _update(price_,totalsupply_,minPrice_); 
         
     }
     
     function _update(uint  price_, uint totalsupply_, uint minPrice_) private {
         minPrice = minPrice_;
         
         if (!(restTime() > 0)) {
            price = price_;    
         }
         
         
         if ((price_ > minPrice) || totalsupply_==0 ) {
            price = 0;
            amount = 0;
         } 
         
         if (restTime()==0 && targetPrice>price_ && price_> 0 && totalsupply_> 0) {
            amount = targetPrice.sub(price).mul(totalsupply_).div(one8).div(priceDiscount);
            price = price_;
            startTime = now;
         }    
         
     }
     
}
