pragma solidity ^0.6.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "remix_accounts.sol";
import "../github/rybarek/CHF-Stablecoin/StableCoin.sol";


// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite {
    
    // StableCoin coin;
    StableCoin coin;
    address currentAccount;
    address accountSpender; 
    address accountRecipient;
    
    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        
        coin = new StableCoin("CHF StableCoin","CHFC",0);
        currentAccount = coin.getMsgSender();
        accountRecipient = TestsAccounts.getAccount(1);
        
    }


    function testTransferOwnership() public {
        Assert.equal(coin.owner(),currentAccount,"Incorrect owner");
        coin.transferOwnership(accountRecipient);
        Assert.equal(coin.owner(),accountRecipient,"Incorrect owner");
        try coin.transferOwnership(currentAccount) {
            Assert.equal(true,false,"TransferOwnership should not be possible");
        } catch {
            Assert.equal(true,true,"Error, ok");
        }
        
        
    } 

    

}
