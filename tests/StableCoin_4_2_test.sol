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
        coin.setScPrice(9400000000);
        coin.addMinter(currentAccount);
        Assert.equal(coin.mint(currentAccount,500), true, "Mint not succesful");
        Assert.equal(coin.mint(TestsAccounts.getAccount(1),9500), true, "Mint not succesful");
    }

    function testBuyBond2() public {
        Assert.equal(coin.buyBond(100),true,"Bying bond nodt succesful");
        coin.setScPrice(9200000000);
        Assert.equal(coin.bc().amount(),757,"Incorrect number of bonds");
        Assert.equal(coin.buyBond(100),true,"Bying bond nodt succesful");
        Assert.equal(coin.getBondAmount(currentAccount),200,"Incorrect amount");
        Assert.equal(coin.getBondPrice(currentAccount),6510000000,"Incorrect price");
        Assert.equal(coin.balanceOf(currentAccount),371,"Incorrect number of coins");
        Assert.equal(coin.totalSupply(),9871,"Incorrect totalSupply");
        Assert.equal(coin.bc().amount(),657,"Incorrect number of bonds");
    }
    
/*    function testBuyBond3() public {
        try coin.buyBond(600) {
            Assert.equal(true,false,"It should fail because of luck of coins");
        } catch {
            Assert.equal(true,true,"Failed as expected, not enough coins");
        } 
    
    } */
    
}
