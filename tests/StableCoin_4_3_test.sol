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
        coin.addMinter(currentAccount);
        Assert.equal(coin.mint(currentAccount,500), true, "Mint not succesful");
        Assert.equal(coin.mint(TestsAccounts.getAccount(1),9500), true, "Mint not succesful");
    }
    
    function testBuyBond3() public {
        coin.setScPrice(9200000000);
        Assert.equal(coin.buyBond(200),true,"Bying bond nodt succesful");
        try coin.buyBond(600) {
            Assert.equal(true,false,"It should fail because of luck of coins");
        } catch {
            Assert.equal(true,true,"Failed as expected, not enough coins");
        } 
    
    } 
    
}
