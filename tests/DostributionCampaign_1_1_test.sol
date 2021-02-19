pragma solidity ^0.6.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
// import "remix_accounts.sol";
import "../github/rybarek/CHF-Stablecoin/DistributionCampaign.sol";


// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite {
    
    
    
    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        
    }
    
   function testBc_1() public {
        DistributionCampaign dc = new DistributionCampaign(10400000000,10000);
        Assert.equal(dc.price(),10400000000, "Incorrect ");
        Assert.equal(dc.amount(),400, "Incorrect");
    }
    
    function testBc_2() public {
        DistributionCampaign dc = new DistributionCampaign(12100000000,100000);
        Assert.equal(dc.price(),12100000000, "Incorrect ");
        Assert.equal(dc.amount(),21000, "Incorrect");
    }
    
    function testBc_3() public {
        DistributionCampaign dc = new DistributionCampaign(0,0);
        Assert.equal(dc.price(),0, "Incorrect ");
        Assert.equal(dc.amount(),0, "Incorrect");
    }
    
    function testBc_4() public {
        DistributionCampaign dc = new DistributionCampaign(9400000000,10000);
        Assert.equal(dc.price(),0, "Incorrect");
        Assert.equal(dc.amount(),0, "Incorrect");
    }
    
    function testBc_5() public {
        DistributionCampaign dc = new DistributionCampaign(0,1000);
        Assert.equal(dc.price(),0, "Incorrect ");
        Assert.equal(dc.amount(),0, "Incorrect");
    }
    
    function testBc_6() public {
        DistributionCampaign dc = new DistributionCampaign(10400000000,0);
        Assert.equal(dc.price(),0, "Incorrect ");
        Assert.equal(dc.amount(),0, "Incorrect");
    }
    
    

}
