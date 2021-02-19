pragma solidity ^0.6.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "remix_accounts.sol";
import "../github/rybarek/CHF-Stablecoin/StableCoin.sol";


// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite {
    
    // StableCoin coin;
    StableCoin coin;
    address currentAccount;
    
    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        
        coin = new StableCoin("CHF StableCoin","CHFC",0);
        currentAccount = coin.getMsgSender();
    }

    function testAddMinter() public {
        Assert.equal(coin.isMinter(currentAccount), false, "Is not minter");
        coin.addMinter(currentAccount);
        Assert.equal(coin.isMinter(currentAccount), true, "Is minter");
    }
    
    function testMintToExternalAccount() public {
        address account = TestsAccounts.getAccount(1);
        Assert.equal(coin.balanceOf(account), 0, "Incorrect balance");
        Assert.equal(coin.mint(account,10), true, "Mint not succesful");
        Assert.equal(coin.balanceOf(account), 10, "Incorrect balance");
        Assert.equal(coin.totalSupply(), 10, "Incorrect total totalSupply");
    }
    
     function testMintToCurrentAccount() public {
        Assert.equal(coin.balanceOf(currentAccount), 0, "Incorrect balance");
        Assert.equal(coin.mint(currentAccount,90), true, "Mint not succesful");
        Assert.equal(coin.balanceOf(currentAccount), 90, "Incorrect balance");
        Assert.equal(coin.totalSupply(), 100, "Incorrect total totalSupply");
    }
    
    function testRemoveMinter() public {
        Assert.equal(coin.isMinter(currentAccount), true, "Is minter");
        coin.removeMinter(currentAccount);
        Assert.equal(coin.isMinter(currentAccount), false, "Is not minter");
    }
    

}
