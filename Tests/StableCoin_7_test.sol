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
    address notShareHolder;
    uint256 internal one8 = uint256(100000000);
   
    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        coin = new StableCoin("CHF StableCoin","CHFC");
        coin.setScPrice(9400000000);
        currentAccount = coin.getMsgSender();
        shareHolder1 = TestsAccounts.getAccount(1);
        shareHolder2 = TestsAccounts.getAccount(2);
        notShareHolder = TestsAccounts.getAccount(3);
        Assert.equal(coin.addShareHolder(shareHolder1,10),true,"Adding Shareholder failed");
        Assert.equal(coin.addShareHolder(shareHolder2,100),true,"Adding Shareholder failed");
        Assert.equal(coin.addShareHolder(currentAccount,100),true,"Adding Shareholder failed");
        coin.updateParams();
    }
    
    
    
    /* function testIsShareHolder() public {
        Assert.equal(coin.isShareHolder(currentAccount),true,"Shareholder");
        Assert.equal(coin.isShareHolder(shareHolder1),true,"Shareholder");
        Assert.equal(coin.isShareHolder(shareHolder2),true,"Shareholder");
        Assert.equal(coin.isShareHolder(notShareHolder),false,"Not shareholder");
    } */
    
    /* function testCoinsToDistribute1() public {
        Assert.equal(coin.dc().amount(),0,"Incorrect number of coins");
    } */
    
    function testCoinsToDistribute2() public {
        coin.setScPrice(10500000000);
        coin.updateParams();
        Assert.equal(coin.dc().amount(),105,"Incorrect number of coins");
    }
    
    function testDistributeCoins() public {
        // Assert.equal(coin.dc().amount(),105,"Incorrect number of coins");
        // Assert.equal(coin.balanceOf(currentAccount),1000,"Incorrect number of coins");
        
        Assert.equal(coin.distributeCoins(),true,"Distribution not possible");
        
        Assert.equal(coin.dc().amount(),105,"Incorrect number of coins");
        Assert.equal(coin.balanceOf(currentAccount),1050,"Incorrect number of coins");
    }
    
}
