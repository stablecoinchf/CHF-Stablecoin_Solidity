pragma solidity ^0.6.0;

import "./SafeMath.sol";

contract DistributionCampaign  {
    
    using SafeMath for uint256;
   
    uint one8 = uint256(100000000);
    
    uint targetPrice = uint256(100).mul(one8);
    
    uint public price;
    
    uint public amount;
    
    
    mapping (address => bool) private _participant;
    
    constructor (uint price_ , uint totalsupply_ ) public {
         if (price_>targetPrice && price_> 0 && totalsupply_> 0) {
            amount = price_.sub(targetPrice).mul(totalsupply_).div(one8).div(100);
            price = price_;
        } else {
            amount = 0;
            price = 0;
        }
        
    }
    
    function isParticipant(address address_) public view returns (bool) {
        return _participant[address_];
    }
    
    function setParticipant(address address_) public {
        _participant[address_] = true ;
    }
    
}
