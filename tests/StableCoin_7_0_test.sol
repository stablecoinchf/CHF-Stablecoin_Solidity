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
        // coin.setScPrice(9400000000);
        Assert.equal(coin.addShareHolder(TestsAccounts.getAccount(1),10),true,"Adding Shareholder failed");
        Assert.equal(coin.addShareHolder(TestsAccounts.getAccount(2),100),true,"Adding Shareholder failed");
        Assert.equal(coin.addShareHolder(currentAccount,100),true,"Adding Shareholder failed");
    }
    
    
    
    function testIsShareHolder() public {
        Assert.equal(coin.isShareHolder(currentAccount),true,"Shareholder");
        Assert.equal(coin.isShareHolder(TestsAccounts.getAccount(1)),true,"Shareholder");
        Assert.equal(coin.isShareHolder(TestsAccounts.getAccount(2)),true,"Shareholder");
        Assert.equal(coin.isShareHolder(TestsAccounts.getAccount(3)),false,"Not shareholder");
    }
    
    function testCoinsToDistribute1() public {
        Assert.equal(coin.dc().amount(),0,"Incorrect number of coins");
    } 
    
}
