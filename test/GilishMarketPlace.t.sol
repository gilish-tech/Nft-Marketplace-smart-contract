// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test,console} from "forge-std/Test.sol";
import {GilishMarketPlace} from "../src/GilishMarketPlace.sol";
import {GilishMarketPlaceScript} from "../script/GilishMarketPlace.s.sol";




contract GilishMarketPlaceTest is Test{
    error GilishMarketPlace__InsufficientPayment();
    error GilishMarketPlace__InsufficientPayments();
    GilishMarketPlace gilishMarketPlace;
    uint256 constant DEFAULT_NFT_PRICE = 0.01 ether;
    uint256 constant TOKEN_CUSTOM_PRICE = 0.05 ether;
    string private constant BASE_TOKEN_URI = "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/";
    // address OWNER = makeAddr("owner");
    address OWNER ;
    uint256 owner;
    address STRANGER = makeAddr("stranger");


    function setUp() public {
        GilishMarketPlaceScript gilishMarketPlaceScript = new GilishMarketPlaceScript();
        (gilishMarketPlace, owner) = gilishMarketPlaceScript.run();
        // vm.prank(OWNER);
        OWNER = makeAddr("mamam");
        vm.deal(STRANGER, 100 ether);
    }


    function testIfBaseFeeIsSet()public{
       
        console.log(gilishMarketPlace.getDefaultNftPrice());
        assertEq(gilishMarketPlace.getDefaultNftPrice() , DEFAULT_NFT_PRICE);
       
    }

    function testIfContractReturnsValidTokenUri(uint256 value) public{
        vm.startBroadcast();
        string memory expectedTokenUri = string.concat(BASE_TOKEN_URI,vm.toString(value));
        console.log(expectedTokenUri);
        vm.stopBroadcast();
        assertEq(expectedTokenUri ,gilishMarketPlace.getTokenUri(value));
    }


    function testIfPriceRetrunsDefaultPriceIfNotSet(uint256 value)public{
        assertEq(gilishMarketPlace.getPriceOfNft(value),DEFAULT_NFT_PRICE);
    }


    function testIfItReturnsTheActualPriceIfSet()public{
        vm.startBroadcast(owner);
        gilishMarketPlace.setTokenPrice(1,TOKEN_CUSTOM_PRICE);
        vm.stopBroadcast();
        
        assertEq(gilishMarketPlace.getPriceOfNft(1),TOKEN_CUSTOM_PRICE);
        
    }

    function testIfItRevertIfNonOwnerTriesToAddOrChangePrice()public{
        vm.prank(STRANGER);
        vm.expectRevert();
        gilishMarketPlace.setTokenPrice(1,TOKEN_CUSTOM_PRICE);
       
    }

    function testIfItRevertsIfUsersPaysLessAmountToMintNFT()public{
        // vm.prank(STRANGER);
        vm.expectRevert();
        console.log(address(STRANGER).balance);
        gilishMarketPlace.MintAnNft{value:DEFAULT_NFT_PRICE - 1}(1);
       
    }
    function testIfItRevertsWhenPriceIsChanged()public{
      
       
         vm.startBroadcast(owner);
         gilishMarketPlace.setTokenPrice(1,TOKEN_CUSTOM_PRICE);
         vm.stopBroadcast();
        vm.expectRevert(GilishMarketPlace__InsufficientPayment.selector);
         gilishMarketPlace.MintAnNft{value:DEFAULT_NFT_PRICE}(1);
       
    }



    function testIfUsersCanMintAnNft()public{       
         vm.startBroadcast(owner);
         gilishMarketPlace.setTokenPrice(1,TOKEN_CUSTOM_PRICE);
         vm.stopBroadcast();
         vm.prank(STRANGER);
         gilishMarketPlace.MintAnNft{value:TOKEN_CUSTOM_PRICE}(1);
              
    }


    modifier DepositToSmartContract(){
        for(uint160 i =1; i<=10; i++){
            hoax(address(i),10 ether);
            gilishMarketPlace.MintAnNft{value:TOKEN_CUSTOM_PRICE}(1);
        }
        _;

    }

    function testIfOwnerCanWithdrawlFunds()public DepositToSmartContract{

        uint256 initialOwnerBalance = vm.addr(owner).balance;
        vm.startBroadcast(owner);
        gilishMarketPlace.witdrawal();
        vm.stopBroadcast();
        uint256 currentBalance = vm.addr(owner).balance;

        assertEq(currentBalance, initialOwnerBalance + (TOKEN_CUSTOM_PRICE * 10));
        
        
     

    }

    function testForRevertsIfNonOwnerTriesToWithdrawl()public DepositToSmartContract{
        
        vm.expectRevert();
        vm.prank(STRANGER);
        gilishMarketPlace.witdrawal();


    
     

    }
    function testTokenUri()public  DepositToSmartContract {
        
      assertEq(string.concat(BASE_TOKEN_URI,vm.toString(uint256(1))),gilishMarketPlace.tokenURI(1));
      assertEq(string.concat(BASE_TOKEN_URI,vm.toString(uint256(1))),gilishMarketPlace.tokenURI(2));
   

    }
    function testTokenUri_sp()public  DepositToSmartContract {
        
      assertEq(string.concat(BASE_TOKEN_URI,vm.toString(uint256(1))),gilishMarketPlace.tokenURI(1));
      assertEq(string.concat(BASE_TOKEN_URI,vm.toString(uint256(1))),gilishMarketPlace.tokenURI(2));
   

    }

        function testIfContractRevertOnFailTransaction()public{

      RejectTransfer rejectTransfer = new RejectTransfer();
      vm.expectRevert(GilishMarketPlace.GilishMarketPlace__ProblemWithdrawingFunds.selector);
      rejectTransfer.rejectImmediately();
    }


}



contract RejectTransfer{
    GilishMarketPlace gilishMarketPlace;
    constructor (){
        gilishMarketPlace = new GilishMarketPlace(uint256(0.1 ether));
    }

    function rejectImmediately()public{
        gilishMarketPlace.witdrawal();

    }
    fallback() external{
        revert("i do not want");
    }
}
