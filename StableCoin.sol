pragma solidity >=0.7.6 <0.8.0;

import "./Roles.sol";
import "./Ownable.sol";

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract StableCoin is ERC20, Ownable {
    using Roles for Roles.Role;
    
    Roles.Role private _minters;
    
    /**
     * @dev Emitted when account get access to {MinterRole}
     */
    event MinterAdded(address indexed account);
    
   
    event MinterRemoved(address indexed account);
    
    
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
    
    function burn(uint256 amount) external onlyMinter returns (bool) {
        _burn(_msgSender(), amount);
    }

   
    function addMinter(address account) external onlyOwner  {
        _addMinter(account);
    }
    
 
    function renmoveMinter(address account) external onlyOwner {
        _removeMinter(account);
    }
    
    modifier onlyMinter() {
        require(
            isMinter(_msgSender()),
            "MinterRole: caller does not have the Minter role"
        );
        _;
    }
   
    function isMinter(address account) public view returns (bool) {
        return _minters.has(account);
    }
    
    // Internal functions
    function _addMinter(address account) internal  {
        _minters.add(account);
        emit MinterAdded(account);
    }
    
    function _removeMinter(address account) internal {
        _minters.remove(account);
        emit MinterRemoved(account);
    }

    
}