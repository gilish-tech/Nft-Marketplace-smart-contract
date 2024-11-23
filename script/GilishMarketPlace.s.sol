// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script,console} from "forge-std/Script.sol";
import {GilishMarketPlace} from "../src/GilishMarketPlace.sol";
import {HelperConfigScript} from "./HelperConFigScript.sol";




contract GilishMarketPlaceScript is Script{

    //  gilishMarketPlace;

    uint256 constant DEFAULT_NFT_PRICE = 0.01 ether;
    


    function deployContract()public returns(GilishMarketPlace,uint256){
    HelperConfigScript helperConfigScript = new HelperConfigScript();
    (uint256  owner)=helperConfigScript.activeHelperConfig();
    vm.startBroadcast(owner);
    GilishMarketPlace gilishMarketPlace = new GilishMarketPlace(DEFAULT_NFT_PRICE);
    vm.stopBroadcast();
    console.log("owner",gilishMarketPlace.owner());
    return (gilishMarketPlace,owner);

    }

    function run()external returns(GilishMarketPlace,uint256){
        
        (GilishMarketPlace gilishMarketPlace, uint256 owner) = deployContract();
          
        return (gilishMarketPlace,owner);


    }





}



