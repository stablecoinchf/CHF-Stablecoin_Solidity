pragma solidity ^0.6.0;

import "./SafeMath.sol";

contract DividendCampaign  {
    
    using SafeMath for uint256;
   
    uint internal one8 = uint(100000000);
    
    uint internal one18 = uint(1000000000000000000);
    

    uint  duration = 604800;
    
    uint public amountETH;
    
    uint public startTime;
    
    bool public active = false;

    mapping (address => dividend) private _dividends;
    
    struct dividend {
        uint amount; //Amount of coins
        uint price; //Price in ETH
    }
    
    constructor (uint _amountETH ) public {
        _start(_amountETH);
    }
    
    function getDividendAmount(address address_) public view returns (uint) {
        return _dividends[address_].amount;
    }
    
    function getDividendPrice(address address_) public view returns (uint) {
        return _dividends[address_].price;
    }
    
    function dividendPayed(address address_) public view returns (bool) {
        return (_dividends[address_].amount > 0);
    }
    
    function getRestTime() public view returns (uint) {
        uint resttime = now - startTime;
        if (resttime >= duration) {
            resttime = 0;
        } else {
            resttime = duration - resttime;
        }
        return resttime;
    }
    
    
    function update() public {
         if ((now - startTime)>duration) {
            _stop();
         }    
     }
     
    
     function getDividendProShare(uint _totalNoOfShares, uint _priceCHFETH, uint _collateralLevel) public view returns (uint) {
        uint dividend = 0;
        if (_totalNoOfShares>0) {
            dividend = amountETH.mul(one18).div(_totalNoOfShares);
        }
    
        dividend = dividend.mul(one8).div(_priceCHFETH);
        
        if (_collateralLevel< one18.mul(100)) {
            dividend = dividend.mul(50).div(100);
        }
        if (_collateralLevel< one18.mul(50)) {
            dividend = dividend.mul(50).div(100);
        } 
        
        return dividend;
    }
     
    function createDividend(address account, uint _noOfShares, uint _totalNoOfShares, uint _priceCHFETH, uint _collateralLevel) public  returns (bool) {
        
        uint noCoins = _noOfShares.mul(getDividendProShare(_totalNoOfShares,_priceCHFETH,_collateralLevel)).div(one18);
        
        uint share = _noOfShares.mul(one18).div(_totalNoOfShares);
        uint price = share.mul(amountETH).div(one18);
        
        _dividends[account] = dividend(noCoins,price);
        
        return true;
    }
     
    function _start(uint _amountETH) private {
        if (_amountETH>0) {
            amountETH = _amountETH;
            active = true;
            startTime = now;    
        } else {
            _stop();
        }
        
     }
     
     function _stop() private {
        amountETH = 0;
        active = false;
        startTime = 0;
     }
    
}
