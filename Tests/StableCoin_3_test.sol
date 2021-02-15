pragma solidity ^0.6.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "remix_accounts.sol";
import "../github/rybarek/CHF-Stablecoin/StableCoin.sol";


// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite {
    
    // StableCoin coin;
    StableCoin coin;
    address currentAccount;
    uint256 internal one8 = uint256(100000000);
   
    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        coin = new StableCoin("CHF StableCoin","CHFC");
        currentAccount = coin.getMsgSender();
    }


    function testScPrice() public {
        Assert.equal(coin.scPrice(),94 * one8,"Incorrect price");
    }
    
    function testBondsToWrite1() public {
        Assert.equal(coin.bondsToWrite(),0,"Incorrect number of bonds");
    } 
    
    function testBondsToWrite2() public {
        coin.addMinter(currentAccount);
        Assert.equal(coin.mint(currentAccount,10000), true, "Mint not succesful");
        coin.updateParams();
        Assert.equal(coin.bondsToWrite(),857,"Incorrect number of bonds");
    } 
    
    function testBondsToWrite3() public {
        coin.addBurner(currentAccount);
        Assert.equal(coin.burn(1000), true, "Burn not succesful");
        coin.updateParams();
        Assert.equal(coin.bondsToWrite(),857,"Incorrect number of bonds");
    } 
    
    function testBondsToWrite4() public {
        coin.setScPrice(10100000000);
        coin.updateParams();
        Assert.equal(coin.bondsToWrite(),0,"Incorrect number of bonds");
    }
    
    function testBondsToWrite5() public {
        coin.setScPrice(9400000000);
        coin.updateParams();
        Assert.equal(coin.bondsToWrite(),771,"Incorrect number of bonds");
    }
    
    function testBondsToWrite6() public {
        Assert.equal(coin.bondsToWrite(),771,"Incorrect number of bonds");
        Assert.equal(coin.buyBond(600),true,"Bying bond nodt succesful");
        Assert.equal(coin.bondsToWrite(),171,"Incorrect number of bonds");
    }
    
    function testBondsToWrite7() public {
        Assert.equal(coin.bondsToWrite(),171,"Incorrect number of bonds");
        Assert.equal(coin.buyBond(100),true,"Bying bond nodt succesful");
        Assert.equal(coin.bondsToWrite(),731,"Incorrect number of bonds");
    }

}
