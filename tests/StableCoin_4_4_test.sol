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
    

    function testBuyBond1() public {
        Assert.equal(coin.mint(coin.getMsgSender(),500), true, "Mint not succesful");
        Assert.equal(coin.mint(TestsAccounts.getAccount(1),8500), true, "Mint not succesful"); 
        coin.setScPrice(9400000000);
        Assert.equal(coin.bc().amount(),771,"Incorrect number of bonds");
        
        try coin.buyBond(772) {
            Assert.equal(true,false,"It should fail because therem is not enough bonds to sell");
        } catch {
            Assert.equal(true,true,"Failed as expected, not enough bonds to sell");
        }
    }

    
    
}
