// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script,console} from "forge-std/Script.sol";


contract HelperConfigScript is Script{

    uint256 constant ANVIL_PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    HelperConfig public activeHelperConfig;

    struct HelperConfig {
        uint256 privatekey;

     
    }

    constructor(){
        if(block.chainid == 11155111){
            console.log(block.chainid);
            activeHelperConfig = getSepoliaConfig();

        }
        else if(block.chainid == 1337){
            activeHelperConfig = getGanacheConfig();

        }
        else if(block.chainid == 1){
            activeHelperConfig = getMainetConfig();

        }
       else{
            activeHelperConfig = getAnvilConfig();

        }
    }




    function getAnvilConfig() public pure returns  (HelperConfig memory){
        return HelperConfig({privatekey: ANVIL_PRIVATE_KEY});

    }


    function getGanacheConfig()public view returns (HelperConfig memory){
        return HelperConfig({privatekey: vm.envUint("GANACHE_PRIVATE_KEY")});
       }


    function getSepoliaConfig()public view returns (HelperConfig memory){
        return HelperConfig({privatekey: vm.envUint("SEPOLIA_PRIVATE_KEY")});
       }

    function getMainetConfig()public view returns (HelperConfig memory){
        return HelperConfig({privatekey: vm.envUint("MAINET_PRIVATE_KEY")});
       }

}