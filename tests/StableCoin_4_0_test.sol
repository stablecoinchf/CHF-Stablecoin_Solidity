pragma solidity ^0.6.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "remix_accounts.sol";
import "../github/rybarek/CHF-Stablecoin/StableCoin.sol";


// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite {
    
    // StableCoin coin;
    StableCoin coin;
    
   
    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        coin = new StableCoin("CHF StableCoin","CHFC",0);
        coin.addMinter(coin.getMsgSender());
    }
    
    function testCreateBondCampaigm() public {
        Assert.equal(coin.bc().price(),0,"Incorrect price");
        Assert.equal(coin.bc().amount(),0,"Incorrect number of bonds");
        coin.setScPrice(9400000000);
        Assert.equal(coin.scPrice(),9400000000,"Incorrect price");
        Assert.equal(coin.bc().price(),0,"Incorrect price");
        Assert.equal(coin.bc().amount(),0,"Incorrect number of bonds");
        Assert.equal(coin.mint(coin.getMsgSender(),500), true, "Mint not succesful");
        Assert.equal(coin.mint(TestsAccounts.getAccount(1),8500), true, "Mint not succesful"); 
        Assert.equal(coin.bc().price(),9400000000,"Incorrect price");
        Assert.equal(coin.bc().amount(),771,"Incorrect number of bonds");
    }
    
}
