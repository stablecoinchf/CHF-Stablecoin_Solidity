pragma solidity ^0.6.2;

import "./DividendCampaign.sol";
import "./BondCampaign.sol";
import "./Prices.sol";

import "./Ownable.sol";

import "./ERC20.sol";
import "./SafeMath.sol";

contract StableCoin is ERC20, Ownable {
    
    using SafeMath for uint256;

    /* Environmnet
    * 0 - Remix
    * 1 - Kovan
    * 2 - Rinkeby
    * 10 - Main
    */
    uint public env;
    
    // Price in percentage of the basis value
    uint public scPrice;
    bool public autoScPrice;
    
    // Internal and private attributes
    uint internal one8 = uint(100000000);
    uint internal one10 = uint(10000000000);
    uint internal one18 = uint(1000000000000000000);
    uint internal targetPrice = uint(100).mul(one8);
    
    uint public minPrice = uint(98).mul(one8);
    uint public maxPrice = uint(102).mul(one8);
   
    uint public conversionFee = uint(20);
   
    uint public icoPrice = uint(120).mul(one8);
    uint public icoCoinsPerShare = uint(10); 
    
    uint public partOperations = uint(15);
    uint public partDividends = uint(15);
    
    uint public ethOperations;
    uint public ethDividends;
    uint public ethInvestment;
    
    
    BondCampaign public bc;
    
    DividendCampaign public dc;
    
    struct bond {
        uint amount; //Amount of tokens the bond contract is for
        uint price; //Price in percentage contract token that bond writer charges
    }
    
    mapping (address => bond) private _bonds;
    
    struct share {
        uint amount; //Amount of tokens the bond contract is for
        uint price;  //Price in ETH
    }
    
    mapping (address => share) private _shares;
    
    uint public totalNoOfShares = 0;
    

    constructor (string memory name_, string memory symbol_, uint env_) public  ERC20(name_, symbol_) {
        env = env_;
        scPrice = targetPrice;
        autoScPrice = false;
        bc = new BondCampaign(0,0, minPrice);
        dc = new DividendCampaign(0);
        updateParams_(0);
    }
    
    function  refresh() external  {
        updateParams_(0);
    }
    
    function  getBalanceETH() public view returns (uint) {
        return address(this).balance;
    }
    
    
    function  setScPriceAuto(bool _autoScPrice) external onlyOwner {
        autoScPrice =  _autoScPrice;
        updateParams_(0);
    }
    
    function  setScPrice(uint  _scPrice) external onlyOwner {
        scPrice =  _scPrice;
        updateParams_(0);
    }
    
    function updateParams_(uint _value) internal {
        
        if (_value> 0) {
             ethOperations = ethOperations.add(_value.mul(partOperations).div(100));
             ethDividends = ethDividends.add(_value.mul(partDividends).div(100));
         }
         
        
         if (autoScPrice)  {
             scPrice =  getAutoPrice(now);
         }
         
         bc.update(scPrice,totalSupply(), minPrice);
         
         if (dc.active()) {
             dc.update();
         }
         if (!dc.active() && ethDividends>0) {
             dc = new DividendCampaign(ethDividends);
         }
         
    }
    
    function getCollateralETH() public view returns (uint) {
        return getBalanceETH().sub(ethOperations).sub(ethDividends).sub(ethInvestment);
    }
    
    
    function getCollateralLevel() public view returns (uint) {
        uint coinsValue = totalSupply().mul(getPrice_CHF_ETH()).div(one8);
        uint level = 0;
        if (coinsValue >0) {
           level = one18.mul(getCollateralETH()).div(coinsValue).mul(100);
        }
        return level;
    }
    
    function getPrice_CHF_ETH() public view returns (uint)   {
        return Prices.getPrice_CHF_ETH(env);
    }
    
    function getPrice_ETH_CHF() public view returns (uint)   {
        return Prices.getPrice_ETH_CHF(env);
    }
    
    function getAutoPrice(uint timestamp) public view returns (uint)   {
        return Prices.getAutoPrice(timestamp);
    }
     
    function addShareHolder(address account, uint amount) external onlyOwner returns (bool)   {
        _addShareHolder(account,amount);
        return true;
    }
    
    function _addShareHolder(address account, uint amount) internal {
        require(amount>0);
        uint newAmount = getShareAmount(account).add(amount);
        uint newPrice = (getSharePrice(account).mul(getShareAmount(account))).div(getShareAmount(account).add(amount));
        _shares[account] = share(newAmount,newPrice);
        _mint(account,amount.mul(icoCoinsPerShare));
        totalNoOfShares = totalNoOfShares.add(amount);
        updateParams_(0);
    }
    
    function buyShare(uint amount) external payable  returns (bool)   {
        updateParams_(0);
        require(amount>0);
        uint transactionpriceCoins = amount.mul(getPrice_CHF_ETH()).mul(icoCoinsPerShare).div(one8);
        uint transactionprice = transactionpriceCoins.mul(icoPrice).div(one8).div(100);
        
        _addShareHolder(getMsgSender(),amount);
         
        updateParams_(transactionpriceCoins);
        ethInvestment = ethInvestment.add(transactionprice.sub(transactionpriceCoins));
        
        require(msg.value >= transactionprice);
        
        return true;
    }
    
     function buyCoin(uint amount) external payable  returns (bool)   {
        updateParams_(0);
        require(amount>0, "Amount not > 0");
        uint transactionprice = amount.mul(getPrice_CHF_ETH()).mul(maxPrice).div(one18);
        _mint(getMsgSender(),amount);
        updateParams_(msg.value);
        require(msg.value >= transactionprice, "Incorrect transactionsprice");
        return true;
    }
    
    function sellCoin(uint amount) external returns (bool)   {
        updateParams_(0);
        require(bc.getCoinBuyPrice(scPrice)>0);
        require(amount>0);
        require(balanceOf(getMsgSender())>=amount);
        require(bc.getAmountOfCoins()>=amount, "Amount to b big");
        uint transactionprice = amount.mul(getPrice_CHF_ETH()).mul(bc.getCoinBuyPrice(scPrice)).div(one18);
        require(address(this).balance >= transactionprice);
        getMsgSender().transfer(transactionprice);
        _burn(getMsgSender(),amount); 
        bc.coinBought(amount);
         updateParams_(0);
        return true;
    }
    
    
    function getShareAmount(address shareHolder) public view returns (uint) {
        return _shares[shareHolder].amount;
    } 
    
    
    function getSharePrice(address shareHolder) public view returns (uint) {
        return _shares[shareHolder].price;
    }
    
    function isShareHolder(address shareHolder) public view returns (bool) {
        return _shares[shareHolder].amount > 0;
    }
    
    function isDividendAvailable() external view  returns (bool)  {
        bool available = false;
        if (isShareHolder(getMsgSender()) && dc.active() && !dc.dividendPayed(getMsgSender())){
            available = true;
        }
        return available;
    }
    
    function getDividendProShare() public view returns (uint) {
        return dc.getDividendProShare(totalSupply(),getPrice_CHF_ETH(),getCollateralLevel());
    }
    
     function getDividendFee(address bondHolder) public view returns (uint) {
        uint gain = getDividendProShare();
        return getShareAmount(bondHolder).mul(getDividendProShare()).div(one18).mul(getPrice_CHF_ETH()).div(one8).mul(conversionFee).div(100);
    }
    
    
    function getDividend() external payable  returns (bool)  {
        
        updateParams_(0);
        
        require(dc.active());
        require(isShareHolder(getMsgSender()));
        require(!dc.dividendPayed(getMsgSender()));
        
        dc.createDividend(getMsgSender(),balanceOf(getMsgSender()),totalSupply(),getPrice_CHF_ETH(),getCollateralLevel());
        
        require(dc.getDividendAmount(getMsgSender())>0);
        
        uint fee =  getDividendFee(getMsgSender());
        
        _mint(getMsgSender(),dc.getDividendAmount(getMsgSender()));
        
        ethDividends = ethDividends.sub(dc.getDividendPrice(getMsgSender()));
        
        updateParams_(0);
        
        require(msg.value >= fee);
        
        return true;
    } 
    
    
    function isBondHolder(address bondHolder) public view returns (bool) {
        return _bonds[bondHolder].amount > 0;
    }    
    
     function buyBond(uint amount) public  returns (bool)  {
        updateParams_(0);
        uint bondPrice =  bc.getBondPrice();
        uint transactionPrice =  bondPrice.mul(amount).div(100).div(one8);
        require(bc.amount()>=amount);
        require(balanceOf(getMsgSender())>transactionPrice);
        uint newAmount = getBondAmount(getMsgSender()).add(amount);
        uint newPrice = ((getBondPrice(getMsgSender()).mul(getBondAmount(getMsgSender()))).add(bondPrice.mul(amount))).div(getBondAmount(getMsgSender()).add(amount));
        _bonds[getMsgSender()] = bond(newAmount,newPrice);
        _burn(getMsgSender(),transactionPrice);
        bc.bondSold(amount);
        updateParams_(0);
        return true;
    } 
    
    
    function convertBond() external payable  returns (bool)    {
        updateParams_(0);
        uint fee =  getBondConversionFee(getMsgSender());
        require(scPrice>targetPrice);
        require(getBondAmount(getMsgSender())>0);
        uint newCoins = getBondAmount(getMsgSender())%10;
        _mint(getMsgSender(),newCoins);
        _addShareHolder(getMsgSender(),getBondAmount(getMsgSender()).sub(newCoins).div(10));
        delete(_bonds[getMsgSender()]);
        updateParams_(msg.value);
        require(msg.value >= fee);
        return true;
    }
    
    function getBondAmount(address bondHolder) public view returns (uint) {
        return _bonds[bondHolder].amount;
    }
    
    function getBondPrice(address bondHolder) public view returns (uint) {
        return _bonds[bondHolder].price;
    }
    
    function getBondConversionFee(address bondHolder) public view returns (uint) {
        uint gain = targetPrice.sub(getBondPrice(bondHolder));
        return getBondAmount(bondHolder).mul(getPrice_CHF_ETH()).mul(gain).mul(conversionFee).div(100).div(one18);
    }
    
    function getMsgSender() public view returns (address payable) {
        return _msgSender();
    }
    
    
    function mint(address to, uint256 amount)
        external
        onlyOwner
        returns (bool)
    {
        _mint(to, amount);
        updateParams_(0);
        return true;
    }
    
    function burn(uint256 amount) external onlyOwner returns (bool) {
        _burn(_msgSender(), amount);
        updateParams_(0);
        return true;
    }

    
}
