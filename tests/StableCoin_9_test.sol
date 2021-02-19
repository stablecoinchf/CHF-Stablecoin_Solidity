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
    }
    
    function testBuyShare() public payable {
        uint amount = 10;
        uint transactionprice = amount * coin.getPrice_CHF_ETH();
        Assert.equal(transactionprice, 858830, 'Incorrect amount of ether');
        Assert.equal(coin.getPrice_ETH_CHF(),116436959514,"Incorrect price");
        Assert.equal(coin.getPrice_CHF_ETH(),85883,"Incorrect price");
    }
    
    
}
