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

   
    function testTransferToExternalAccount() public {
        coin.addMinter(currentAccount);
        Assert.equal(coin.mint(currentAccount,100), true, "Mint not succesful");
        address accountTo = TestsAccounts.getAccount(1);
        Assert.equal(coin.balanceOf(currentAccount), 100, "Incorrect balance");
        Assert.equal(coin.balanceOf(accountTo), 0, "Incorrect balance");
        Assert.equal(coin.totalSupply(), 100, "Incorrect total totalSupply"); 
        coin.transfer(accountTo, 10);
        Assert.equal(coin.balanceOf(accountTo), 10, "Incorrect balance");
        Assert.equal(coin.balanceOf(currentAccount), 90, "Incorrect balance");
        Assert.equal(coin.totalSupply(), 100, "Incorrect total totalSupply");
    }
    
    
    

}
