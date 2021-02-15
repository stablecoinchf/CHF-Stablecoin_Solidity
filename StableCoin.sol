pragma solidity ^0.6.0;

import "./DistributionCampaign.sol";
import "./Roles.sol";
import "./Ownable.sol";

import "./ERC20.sol";
import "./SafeMath.sol";

contract StableCoin is ERC20, Ownable {
    
    using SafeMath for uint256;
    using Roles for Roles.Role;
    
    // Price in percentage of the basis value
    uint public scPrice;
    
    // Internal and private attributes
    uint256 internal one8 = uint256(100000000);
    uint256 internal targetPrice = uint256(100).mul(one8);
    uint256 internal minPrice = uint256(98).mul(one8);
    uint256 internal maxPrice = uint256(102).mul(one8);
    
    
     // Number of coins to be distributed 
    DistributionCampaign public dc = new DistributionCampaign(0,0);
    
    
    // Number of bonds to be sold
    uint public bondsToWrite = 0;

    // Price discount for the bond in percent
    uint public bondPriceDiscount = 70;
    
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
    
    
    constructor (string memory name_, string memory symbol_) public  ERC20(name_, symbol_) {
        _setScPrice(10000000000);
        updateParams();
    }
    
    
    function  setScPrice(uint newPrice) external onlyOwner {
        _setScPrice(newPrice);
    }
    
     function _setScPrice(uint newPrice) internal {
        scPrice =  uint256(newPrice);
    }
    
    //Updates prices to latest
    function updateParams() public {
         if (scPrice < minPrice) {
            if  (bondsToWrite < 100) {
                bondsToWrite = targetPrice.sub(scPrice).mul(totalSupply()).div(one8).div(bondPriceDiscount);
            }
         } else {
             bondsToWrite = 0;
         }
         if (scPrice > maxPrice)  {
            if  (scPrice != dc.price()) {
               uint coinsToDistribute = scPrice.sub(targetPrice).mul(totalSupply()).div(one8).div(100);
               dc  = new DistributionCampaign(coinsToDistribute,scPrice); 
            }
         } else {
             dc  = new DistributionCampaign(0,0);
         }
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
        _mint(account,amount.mul(10));
        totalNoOfShares = totalNoOfShares.add(amount);
    }
    
    function reduceShares(address account, uint amount) external onlyOwner returns (bool)   {
        require(amount>0);
        uint newAmount = 0;
        if (getShareAmount(account) > amount)  {
            newAmount = getShareAmount(account).sub(amount);
        }
        uint newPrice = getSharePrice(account);
        _shares[account] = share(newAmount,newPrice);
        totalNoOfShares = totalNoOfShares.sub(amount);
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
    
    function distributeCoins() public  returns (bool)  {
        updateParams();
        require(dc.amount()>0);
        require(isShareHolder(getMsgSender()));
        require(!dc.isParticipant(getMsgSender()));
        _mint(getMsgSender(),dc.amount().mul(getShareAmount(getMsgSender())).div(totalNoOfShares));
        dc.setParticipant(getMsgSender());
        updateParams();
        return true;
    }
    
    
     function buyBond(uint amount) public  returns (bool)  {
        updateParams();
        uint bondPrice =  scPrice.mul(bondPriceDiscount).div(100);
        uint transactionPrice =  bondPrice.mul(amount).div(100).div(one8);
        require(bondsToWrite>=amount);
        require(balanceOf(getMsgSender())>transactionPrice);
        uint newAmount = getBondAmount(getMsgSender()).add(amount);
        uint newPrice = ((getBondPrice(getMsgSender()).mul(getBondAmount(getMsgSender()))).add(bondPrice.mul(amount))).div(getBondAmount(getMsgSender()).add(amount));
        _bonds[getMsgSender()] = bond(newAmount,newPrice);
        _burn(getMsgSender(),transactionPrice);
        bondsToWrite = bondsToWrite.sub(amount);
        updateParams();
        return true;
    } 
    
    function executeBond() public  returns (bool)  {
        updateParams();
        require(scPrice>targetPrice);
        require(getBondAmount(getMsgSender())>0);
        uint newCoins = getBondAmount(getMsgSender())%10;
        _mint(getMsgSender(),newCoins);
        _addShareHolder(getMsgSender(),getBondAmount(getMsgSender()).sub(newCoins).div(10));
        delete(_bonds[getMsgSender()]);
        updateParams();
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
        return true;
    }
    
    function burn(uint256 amount) external onlyBurner returns (bool) {
        _burn(_msgSender(), amount);
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
    
    function getMsgSender() public view returns (address) {
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
