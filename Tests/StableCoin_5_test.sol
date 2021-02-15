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
        coin.setScPrice(9400000000);
        currentAccount = coin.getMsgSender();
        coin.addMinter(currentAccount);
        Assert.equal(coin.mint(currentAccount,500), true, "Mint not succesful");
        Assert.equal(coin.mint(TestsAccounts.getAccount(1),9500), true, "Mint not succesful");
        coin.updateParams();
    }
    
    function testExecuteBond1() public {
        coin.setScPrice(10500000000);
        Assert.equal(coin.getBondAmount(currentAccount),0,"Incorrect amount");
        try coin.executeBond() {
            Assert.equal(true,false,"It should fail, no bonds to execute");
        } catch {
            Assert.equal(true,true,"Failed OK");
        }
    }


    function testExecuteBond2() public {
        coin.setScPrice(9400000000);
        Assert.equal(coin.buyBond(100),true,"Bying bond not succesful");
        Assert.equal(coin.balanceOf(currentAccount),435,"Incorrect number of coins");
        Assert.equal(coin.totalSupply(),9935,"Incorrect totalSupply");
        Assert.equal(coin.getBondAmount(currentAccount),100,"Incorrect amount");
        try coin.executeBond() {
            Assert.equal(true,false,"It should fail because the price of the coin is too small");
        } catch {
            Assert.equal(true,true,"Failed OK");
        }
    }
    
    function testExecuteBond3() public {
        coin.setScPrice(10500000000);
        
        /* Assert.equal(coin.balanceOf(currentAccount),435,"Incorrect number of coins");
        Assert.equal(coin.totalSupply(),9935,"Incorrect totalSupply"); */
        
        Assert.equal(coin.executeBond(),true,"Executing bond not succesful");
        Assert.equal(coin.balanceOf(currentAccount),535,"Incorrect number of coins");
        Assert.equal(coin.totalSupply(),10035,"Incorrect totalSupply");
        Assert.equal(coin.getBondAmount(currentAccount),0,"Incorrect amount");
        Assert.equal(coin.totalNoOfShares(),10,"Incorrect totalNoOfShares");
        Assert.equal(coin.getShareAmount(currentAccount),10,"Incorrect number of shares");
    } 
    
    
}
