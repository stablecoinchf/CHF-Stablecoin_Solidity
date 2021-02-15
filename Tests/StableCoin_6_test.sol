pragma solidity ^0.6.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "remix_accounts.sol";
import "../github/rybarek/CHF-Stablecoin/StableCoin.sol";


// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite {
    
    // StableCoin coin;
    StableCoin coin;
    address currentAccount;
    address shareHolder1;
    address shareHolder2;
    uint256 internal one8 = uint256(100000000);
   
    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        coin = new StableCoin("CHF StableCoin","CHFC");
        coin.setScPrice(9400000000);
        currentAccount = coin.getMsgSender();
        shareHolder1 = TestsAccounts.getAccount(1);
        shareHolder2 = TestsAccounts.getAccount(2);
    }
    
    function testAddShareholder() public {
        /* Assert.equal(coin.totalSupply(),0,"Incorrect totalSupply");
        Assert.equal(coin.totalNoOfShares(),0,"Incorrect totalNoOfShares");
        Assert.equal(coin.balanceOf(shareHolder1),0,"Incorrect number of coins");
        Assert.equal(coin.balanceOf(shareHolder2),0,"Incorrect number of coins"); */
        
        Assert.equal(coin.addShareHolder(shareHolder1,10),true,"Adding Shareholder failed");
        Assert.equal(coin.addShareHolder(shareHolder2,100),true,"Adding Shareholder failed");
        
        Assert.equal(coin.totalSupply(),1100,"Incorrect totalSupply");
        Assert.equal(coin.totalNoOfShares(),110,"Incorrect totalNoOfShares");
        Assert.equal(coin.balanceOf(shareHolder1),100,"Incorrect number of coins");
        Assert.equal(coin.getShareAmount(shareHolder1),10,"Incorrect number of shares");
        Assert.equal(coin.getSharePrice(shareHolder1),0,"Incorrect price");
        Assert.equal(coin.balanceOf(shareHolder2),1000,"Incorrect number of coins");
        Assert.equal(coin.getShareAmount(shareHolder2),100,"Incorrect number of shares");
        Assert.equal(coin.getSharePrice(shareHolder2),0,"Incorrect price");
    }
    
    function testReduceShares() public {
        Assert.equal(coin.reduceShares(shareHolder2,60),true,"Reducing shares failed");
        
        Assert.equal(coin.totalSupply(),1100,"Incorrect totalSupply");
        Assert.equal(coin.totalNoOfShares(),50,"Incorrect totalNoOfShares");
        Assert.equal(coin.balanceOf(shareHolder2),1000,"Incorrect number of coins");
        Assert.equal(coin.getShareAmount(shareHolder2),40,"Incorrect number of shares");
        Assert.equal(coin.getSharePrice(shareHolder2),0,"Incorrect price");
    } 

    
}
