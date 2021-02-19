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

    function testName() public {
        Assert.equal(coin.name(),  "CHF StableCoin", "incorrect Message") ;
    }
    
    function testID() public {
        Assert.equal(coin.symbol(),  "CHFC", "incorrect Message") ;
    }
    
    function testTotalSuppply() public {
        Assert.equal(coin.totalSupply(),  uint256(0), "incorrect totalSupply") ;
    }
    
    function testOwnerAccont() public {
        Assert.equal(msg.sender, TestsAccounts.getAccount(0), "Not equal");
    }
    

}
