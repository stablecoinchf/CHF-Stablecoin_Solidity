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
        
        coin = new StableCoin("CHF StableCoin","CHFC");
        
        // Unfortuntelly for the test purpose CurrentAccount and Spender mus be equal
        currentAccount = coin.getMsgSender();
        accountSpender = coin.getMsgSender();
        accountRecipient = TestsAccounts.getAccount(1);
        
        /* currentAccount = coin.getMsgSender();
        accountSpender = TestsAccounts.getAccount(1);
        accountRecipient = TestsAccounts.getAccount(2); */
        
        coin.addMinter(currentAccount);
        Assert.equal(coin.mint(accountSpender,100), true, "Mint not succesful");
    }


    function testTransferOwnership() public {
        Assert.equal(coin.owner(),currentAccount,"Incorrect owner");
        coin.transferOwnership(accountRecipient);
        Assert.equal(coin.owner(),accountRecipient,"Incorrect owner");
        // coin.transferOwnership(currentAccount);
        // Assert.equal(coin.owner(),currentAccount,"Incorrect owner");
    } 

    
    function testIncreaseAllowance() public {
        Assert.equal(coin.allowance(currentAccount,accountSpender), 0, "Is not 0");
        Assert.equal(coin.increaseAllowance(accountSpender,10),true,"increaseAllowance not sucesfull");
        Assert.equal(coin.allowance(currentAccount,accountSpender), 10, "Is not 10");
    }
    
    function testDecreaseAllowance() public {
        Assert.equal(coin.allowance(currentAccount,accountSpender), 10, "Is not 10");
        Assert.equal(coin.decreaseAllowance(accountSpender,1),true,"increaseAllowance not sucesfull");
        Assert.equal(coin.allowance(currentAccount,accountSpender), 9, "Is not 9");
    }
    
    function testTransferFrom1() public {
        Assert.equal(coin.balanceOf(currentAccount), 100, "Incorrect balance");
        Assert.equal(coin.allowance(currentAccount,accountSpender), 9, "Is not 9");
        Assert.equal(coin.transferFrom(accountSpender,accountRecipient, 1),true,"transferFrom not sucesfull");
        Assert.equal(coin.balanceOf(currentAccount), 99, "Incorrect balance");
        Assert.equal(coin.balanceOf(accountRecipient), 1, "Incorrect balance");
        Assert.equal(coin.allowance(currentAccount,accountSpender), 8, "Is not 8");
    }
    
    function testTransferFrom2() public {
        Assert.equal(coin.allowance(currentAccount,accountSpender), 8, "Is not 8");
        Assert.equal(coin.balanceOf(currentAccount), 99, "Incorrect balance");
        Assert.equal(coin.balanceOf(accountRecipient), 1, "Incorrect balance");
        Assert.equal(coin.transferFrom(accountSpender,accountRecipient, 8),true,"transferFrom not sucesfull");
        Assert.equal(coin.balanceOf(currentAccount), 91, "Incorrect balance");
        Assert.equal(coin.balanceOf(accountRecipient), 9, "Incorrect balance");
        Assert.equal(coin.allowance(currentAccount,accountSpender), 0, "Is not 0");
    }
    
    function testTransferFrom3() public {
        Assert.equal(coin.balanceOf(currentAccount), 91, "Incorrect balance");
        Assert.equal(coin.balanceOf(accountRecipient), 9, "Incorrect balance");
        Assert.equal(coin.allowance(currentAccount,accountSpender), 0, "Is not 0");
        // Assert.equal(coin.transferFrom(accountSpender,accountRecipient, 1),false,"transferFrom should not be sucesfull");
    }
    

}
