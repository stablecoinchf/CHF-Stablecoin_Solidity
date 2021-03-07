pragma solidity ^0.6.0;

import "./SafeMath.sol";

contract BondCampaign  {
    
    using SafeMath for uint256;
    
    uint one8 = uint256(100000000);
    
    uint targetPrice  = uint(100).mul(one8);
    
    uint public priceDiscount = 70;
    
    uint public amount;

    uint public price;
    
    
    constructor (uint  price_, uint totalsupply_) public {
        _update(price_,totalsupply_);
    }
    
     function decreaseAmount(uint amount_) public {
        amount = amount.sub(amount_);
    }
    
     function update(uint  price_, uint totalsupply_) public {
        _update(price_,totalsupply_);
     }
     
     function _update(uint  price_, uint totalsupply_) private {
         if (targetPrice>price_ && price_> 0 && totalsupply_> 0) {
            amount = targetPrice.sub(price_).mul(totalsupply_).div(one8).div(priceDiscount);
            price = price_;
        } else {
            price = 0;
            amount = 0;
        }
     }
     
     
}