pragma solidity ^0.6.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "../github/rybarek/CHF-Stablecoin/Inbox.sol";
import "../github/rybarek/CHF-Stablecoin/StableCoin.sol";


// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite {
    
    Inbox inbox;
    StableCoin coin;
    string strInitialMessage;
    string strUpdatedMessage;

    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        
        strInitialMessage="Initial Message";
        strUpdatedMessage="Updated Message";
        inbox = new Inbox(strInitialMessage);
        coin = new StableCoin("CHF StableCoin","CHFC");
    }

    function testGetMessage() public {
        Assert.equal(inbox.getMessage(),  strInitialMessage, "incorrect Message") ;
    }
    
    function testSetMessage() public {
        inbox.setMessage(strUpdatedMessage);
        Assert.equal(inbox.getMessage(),  strUpdatedMessage, "incorrect Message") ;
    }
    
    function testCoin() public {
        Assert.equal(coin.name(),  "CHF StableCoin", "incorrect Message") ;
    }

}
