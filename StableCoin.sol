pragma solidity ^0.6.0;

import "./Roles.sol";
import "./Ownable.sol";

import "./ERC20.sol";

contract StableCoin is ERC20, Ownable {
    using Roles for Roles.Role;
    
    Roles.Role private _minters;
    Roles.Role private _burners;
    
    
    event MinterAdded(address indexed account);
    
    event MinterRemoved(address indexed account);
    
    event BurnerAdded(address indexed account);
   
    event BurnerRemoved(address indexed account);
    
    
    constructor (string memory name_, string memory symbol_) public  ERC20(name_, symbol_) {
     
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
