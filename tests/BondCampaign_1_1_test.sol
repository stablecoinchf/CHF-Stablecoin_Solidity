pragma solidity ^0.6.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
// import "remix_accounts.sol";
import "../github/rybarek/CHF-Stablecoin/BondCampaign.sol";


// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite {
    
    
    
    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        
    }
    
    function testBc_1() public {
        BondCampaign bc = new BondCampaign(9400000000,10000);
        Assert.equal(bc.price(),9400000000, "Incorrect");
        Assert.equal(bc.amount(),857, "Incorrect");
        Assert.equal(bc.priceDiscount(),70, "Incorrect");
    }
    
    function testBc_2() public {
        BondCampaign bc = new BondCampaign(9400000000,9000);
        Assert.equal(bc.price(),9400000000, "Incorrect ");
        Assert.equal(bc.amount(),771, "Incorrect");
    }
    
    function testBc_3() public {
        BondCampaign bc = new BondCampaign(0,0);
        Assert.equal(bc.price(),0, "Incorrect ");
        Assert.equal(bc.amount(),0, "Incorrect");
    }
    
    function testBc_4() public {
        BondCampaign bc = new BondCampaign(10400000000,1000);
        Assert.equal(bc.price(),0, "Incorrect ");
        Assert.equal(bc.amount(),0, "Incorrect");
    }
    
    function testBc_5() public {
        BondCampaign bc = new BondCampaign(0,1000);
        Assert.equal(bc.price(),0, "Incorrect ");
        Assert.equal(bc.amount(),0, "Incorrect");
    }
    
    function testBc_6() public {
        BondCampaign bc = new BondCampaign(9400000000,0);
        Assert.equal(bc.price(),0, "Incorrect ");
        Assert.equal(bc.amount(),0, "Incorrect");
    }
    

}
