pragma solidity ^0.6.2;

// import "./DistributionCampaign.sol";
import "./BondCampaign.sol";
import "./Prices.sol";

import "./Roles.sol";
import "./Ownable.sol";

import "./ERC20.sol";
import "./SafeMath.sol";

contract StableCoin is ERC20, Ownable {
    
    using SafeMath for uint256;
    using Roles for Roles.Role;
    
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
    uint256 internal one8 = uint256(100000000);
    uint256 internal one10 = uint256(10000000000);
    uint256 internal targetPrice = uint256(100).mul(one8);
    uint256 public minPrice = uint256(98).mul(one8);
    uint256 public maxPrice = uint256(102).mul(one8);
    uint256 public icoPrice = uint256(120).mul(one8);
    uint256 public icoCoinsPerShare = uint256(10);
    
    
//    DistributionCampaign public dc;
    
    BondCampaign public bc;
    
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
    
    Roles.Role private _minters;
    
    Roles.Role private _burners;
    
    event MinterAdded(address indexed account);
    
    event MinterRemoved(address indexed account);
    
    event BurnerAdded(address indexed account);
   
    event BurnerRemoved(address indexed account);
    
    
    constructor (string memory name_, string memory symbol_, uint env_) public  ERC20(name_, symbol_) {
        env = env_;
        scPrice = targetPrice;
        autoScPrice = false;
        bc = new BondCampaign(0,0);
        // dc = new DistributionCampaign(0,0);
        updateParams_();
    }
    
    function  getBalanceETH() public view returns (uint) {
        return address(this).balance;
    }
    
    
    function  setScPriceAuto(bool _autoScPrice) external onlyOwner {
        autoScPrice =  _autoScPrice;
        updateParams_();
    }
    
    function  setScPrice(uint  _scPrice) external onlyOwner {
        scPrice =  _scPrice;
        updateParams_();
    }
    
    function updateParams_() internal {
        
         if (autoScPrice)  {
             scPrice =  getAutoPrice(now);
         }
         
         if (scPrice < minPrice) {
            if  (bc.amount() < 100) {
                bc.update(scPrice,totalSupply());
            }
         } else {
             if (bc.amount()>0) {
               bc.update(0,0);
             }  
         } 
         
         /* if (scPrice > maxPrice)  {
            if  (scPrice != dc.price()) {
               dc = new DistributionCampaign(scPrice,totalSupply());
            }
         } else {
              if (dc.amount()>0) {
                dc = new DistributionCampaign(0,0);
              }  
         } */
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
        updateParams_();
    }
    
    /* function reduceShares(address account, uint amount) external onlyOwner returns (bool)   {
        require(amount>0);
        uint newAmount = 0;
        if (getShareAmount(account) > amount)  {
            newAmount = getShareAmount(account).sub(amount);
        }
        uint newPrice = getSharePrice(account);
        _shares[account] = share(newAmount,newPrice);
        totalNoOfShares = totalNoOfShares.sub(amount);
        return true;
    } */
    
    function buyShare(uint amount) external payable  returns (bool)   {
        require(amount>0);
        uint transactionprice = amount.mul(getPrice_CHF_ETH()).mul(icoPrice).mul(icoCoinsPerShare);
        require(msg.value >= transactionprice);
        _addShareHolder(getMsgSender(),amount);
        return true;
    }
    
     function buyCoin(uint amount) external payable  returns (bool)   {
        require(amount>0, "Amount not > 0");
        uint transactionprice = amount.mul(getPrice_CHF_ETH()).mul(maxPrice);
        require(msg.value >= transactionprice, "Incorrect transactionsprice");
        _mint(getMsgSender(),amount);
        return true;
    }
    
    function sellCoin(uint amount) external returns (bool)   {
        require(getBuyPrice()>0);
        require(amount>0);
        require(balanceOf(getMsgSender())>=amount);
        uint transactionprice = amount.mul(getPrice_CHF_ETH()).mul(getBuyPrice());
        require(address(this).balance >= transactionprice);
        getMsgSender().transfer(transactionprice);
        _burn(getMsgSender(),amount); 
        return true;
    }
    
    function getBuyPrice() public view returns (uint){
        uint buyPrice = 0;
        if (scPrice< minPrice) {
            buyPrice = scPrice.mul(102).div(100);
        }
        if (buyPrice > minPrice) {
            buyPrice = minPrice;
        }
        return buyPrice;
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
    
/*    function distributeCoins() public  returns (bool)  {
        updateParams_();
        require(dc.amount()>0);
        require(isShareHolder(getMsgSender()));
        require(!dc.isParticipant(getMsgSender()));
        _mint(getMsgSender(),dc.amount().mul(getShareAmount(getMsgSender())).div(totalNoOfShares));
        dc.setParticipant(getMsgSender());
        updateParams_();
        return true;
    } */
    
    function isBondHolder(address bondHolder) public view returns (bool) {
        return _bonds[bondHolder].amount > 0;
    }    
    
     function buyBond(uint amount) public  returns (bool)  {
        updateParams_();
        uint bondPrice =  scPrice.mul(bc.priceDiscount()).div(100);
        uint transactionPrice =  bondPrice.mul(amount).div(100).div(one8);
        require(bc.amount()>=amount);
        require(balanceOf(getMsgSender())>transactionPrice);
        uint newAmount = getBondAmount(getMsgSender()).add(amount);
        uint newPrice = ((getBondPrice(getMsgSender()).mul(getBondAmount(getMsgSender()))).add(bondPrice.mul(amount))).div(getBondAmount(getMsgSender()).add(amount));
        _bonds[getMsgSender()] = bond(newAmount,newPrice);
        _burn(getMsgSender(),transactionPrice);
        bc.decreaseAmount(amount);
        updateParams_();
        return true;
    } 
    
    function executeBond() public  returns (bool)  {
        updateParams_();
        require(scPrice>targetPrice);
        require(getBondAmount(getMsgSender())>0);
        uint newCoins = getBondAmount(getMsgSender())%10;
        _mint(getMsgSender(),newCoins);
        _addShareHolder(getMsgSender(),getBondAmount(getMsgSender()).sub(newCoins).div(10));
        delete(_bonds[getMsgSender()]);
        updateParams_();
        return true;
    }
    
    function getBondAmount(address bondHolder) public view returns (uint) {
        return _bonds[bondHolder].amount;
    }
    
    function getBondPrice(address bondHolder) public view returns (uint) {
        return _bonds[bondHolder].price;
    }
    
    
    function mint(address to, uint256 amount)
        external
        onlyMinter
        returns (bool)
    {
        _mint(to, amount);
        updateParams_();
        return true;
    }
    
    function burn(uint256 amount) external onlyBurner returns (bool) {
        _burn(_msgSender(), amount);
        updateParams_();
        return true;
    }

   
    function addMinter(address account) external onlyOwner  {
        _addMinter(account);
    }
    
     function addBurner(address account) external onlyOwner  {
        _addBurner(account);
    }
    
 
    function removeMinter(address account) external onlyOwner {
        _removeMinter(account);
    }
    
     function removeBurner(address account) external onlyOwner {
        _removeBurner(account);
    }
    
    modifier onlyMinter() {
        require(
            isMinter(_msgSender()),
            "MinterRole: caller does not have the Minter role"
        );
        _;
    }
    
    modifier onlyBurner() {
        require(
            isBurner(_msgSender()),
            "BurnerRole: caller does not have the Burner role"
        );
        _;
    }
   
    function isMinter(address account) public view returns (bool) {
        return _minters.has(account);
    }
    
     function isBurner(address account) public view returns (bool) {
        return _burners.has(account);
    }
    
    function getMsgSender() public view returns (address payable) {
        return _msgSender();
    }
    
    
    // Internal functions
    function _addMinter(address account) internal  {
        _minters.add(account);
        emit MinterAdded(account);
    }
    
    function _addBurner(address account) internal  {
        _burners.add(account);
        emit BurnerAdded(account);
    }
    
    function _removeMinter(address account) internal {
        _minters.remove(account);
        emit MinterRemoved(account);
    }
    
    function _removeBurner(address account) internal {
        _burners.remove(account);
        emit BurnerRemoved(account);
    }

    
}
