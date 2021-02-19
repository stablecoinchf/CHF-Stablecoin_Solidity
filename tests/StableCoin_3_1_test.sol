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
        currentAccount = coin.getMsgSender();
        coin.addMinter(currentAccount);
        Assert.equal(coin.mint(currentAccount,9000), true, "Mint not succesful");
    }

    
    function testBondsToWrite5() public {
        Assert.equal(coin.bc().amount(),771,"Incorrect number of bonds");
    }
    
    function testBondsToWrite6() public {
        Assert.equal(coin.bc().amount(),771,"Incorrect number of bonds");
        Assert.equal(coin.buyBond(700),true,"Bying bond nodt succesful");
        Assert.equal(coin.bc().amount(),732,"Incorrect number of bonds");
    }
    
    function testBondsToWrite7() public {
        coin.setScPrice(9300000000);
        Assert.equal(coin.bc().amount(),732,"Incorrect number of bonds");
        Assert.equal(coin.buyBond(100),true,"Bying bond nodt succesful");
        Assert.equal(coin.bc().amount(),632,"Incorrect number of bonds");
    }

}
