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
        coin.setScPrice(9400000000);
        Assert.equal(coin.scPrice(),9400000000,"Incorrect price");
        currentAccount = coin.getMsgSender();
        coin.addMinter(currentAccount);
        Assert.equal(coin.mint(currentAccount,500), true, "Mint not succesful");
        Assert.equal(coin.mint(TestsAccounts.getAccount(1),9500), true, "Mint not succesful"); 
        
    }

    function testBuyBond0() public {
        Assert.equal(coin.bc().amount(),857,"Incorrect number of bonds");
        try coin.buyBond(858) {
            Assert.equal(true,false,"It should fail because therem is not enough bonds to sell");
        } catch {
            Assert.equal(true,true,"Failed as expected, not enough bonds to sell");
        }
    }

    
    
}
