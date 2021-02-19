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
    }


    function testScPrice() public {
        Assert.equal(coin.scPrice(),9400000000,"Incorrect price");
    }
    
    function testBondsToWrite1() public {
        Assert.equal(coin.bc().amount(),0,"Incorrect number of bonds");
    } 
    
    function testBondsToWrite2() public {
        coin.addMinter(currentAccount);
        Assert.equal(coin.mint(currentAccount,10000), true, "Mint not succesful");
        Assert.equal(coin.bc().amount(),857,"Incorrect number of bonds");
    } 
    
    function testBondsToWrite3() public {
        coin.addBurner(currentAccount);
        Assert.equal(coin.burn(1000), true, "Burn not succesful");
        Assert.equal(coin.bc().amount(),857,"Incorrect number of bonds");
    } 
    
    function testBondsToWrite4() public {
        coin.setScPrice(10100000000);
        Assert.equal(coin.bc().amount(),0,"Incorrect number of bonds");
    }
    

}
