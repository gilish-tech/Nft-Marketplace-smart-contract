// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;
import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";


/**
 * @author Gilberto Diamond(Gilish_tech)
   @title Gilish-tech Market place
   @notice This is an Nft market place, where user can buy/Mint an Nft
   @dev Users should be able to mint an nft based on some certain amount being set by the owner of the smart contract, however if the price is not set, users will have to pay , the default fee for unset prices.
   @ 
 */
contract GilishMarketPlace is ERC721URIStorage,Ownable {

    error GilishMarketPlace__InsufficientPayment();
    error GilishMarketPlace__ProblemWithdrawingFunds();

     /*//////////////////////////////////////////////////////////////
                            STATE IMMUTABLE VARAIABLES
    //////////////////////////////////////////////////////////////*/
    uint256 private immutable i_defaultNftPrice;
    


     /*//////////////////////////////////////////////////////////////
                            STATE CONSTANT VARAIABLES
    //////////////////////////////////////////////////////////////*/
       string private constant BASE_TOKEN_URI = "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/";
       

     /*//////////////////////////////////////////////////////////////
                            STATE STORAGE VARAIABLES
    //////////////////////////////////////////////////////////////*/
    uint256 private s_nextTokenId;
    mapping(uint256=>uint256) private nftIdToPrice; 
    // uint256;


     /*//////////////////////////////////////////////////////////////
                            EVENTS
    //////////////////////////////////////////////////////////////*/

    event PriceAdded(uint256 indexed tokenID, uint256 indexed tokenPrice);
    event NftMinted(uint256 indexed tokenId);


    
        
    /*//////////////////////////////////////////////////////////////
                         modifier
    //////////////////////////////////////////////////////////////*/

    /**
     *@dev it should revert if the amount is less than the default Nft Price  
     */ 
    modifier mustNotBeLessThanTheNftPrice(uint256 tokenUriId){
        if (msg.value <  _priceOfNft(tokenUriId)){
            revert GilishMarketPlace__InsufficientPayment();
        }
        _;

    }


    // modifier 


        
    
        
    /*//////////////////////////////////////////////////////////////
                         CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice  it sets the default nft price
     */
    constructor(uint256 defaultNftPrice) ERC721("GilishApes", "GAPE")Ownable(msg.sender){
        i_defaultNftPrice = defaultNftPrice;
        

    }







    /*//////////////////////////////////////////////////////////////
                        EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    /**
     * @param tokenUriId this is the id of the nft
     * @param tokenPrice this is the price of the nft 
     * @notice it sets the price of the nft 
     * @dev only owner can change run this function
     */
    function setTokenPrice(uint256 tokenUriId, uint256 tokenPrice ) external onlyOwner{
        nftIdToPrice[tokenUriId] = tokenPrice;
        emit PriceAdded(tokenUriId,tokenPrice);
        
    }
    
        /**
     * @param tokenUriId this is the id of the nft
     * @notice it sets the price of the nft 
     * @notice them amount must not be less than the price of the token
     */

    function MintAnNft(uint256 tokenUriId) external payable mustNotBeLessThanTheNftPrice(tokenUriId){
        uint256 tokenId = s_nextTokenId++;
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, _tokenUri(tokenUriId));

        emit NftMinted(tokenId);

    }


    function witdrawal()external onlyOwner{
        (bool success,) =(msg.sender).call{value:address(this).balance}("");
        if(!success){
            revert GilishMarketPlace__ProblemWithdrawingFunds();
        }

    }

    
 

   

    
    /*//////////////////////////////////////////////////////////////
                        EXTERNAL/PUBLIC VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    
    function getTokenUri(uint256 tokenUriId)external pure returns (string memory){
        return _tokenUri(tokenUriId);
    }


    function getPriceOfNft(uint256 tokenUriId) external view returns(uint256){
        return _priceOfNft(tokenUriId);
    }

    function getDefaultNftPrice()external view returns (uint256){
        return   i_defaultNftPrice;
    }

  



    /*//////////////////////////////////////////////////////////////
                        PRIVATE AND INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/
   
    /**
     * @param tokenUriId this is the id of the nft
     * @return it returns the full url of the tokenUri of the nft
     */
    function _tokenUri(uint256 tokenUriId)internal pure returns  (string memory){
        return string.concat(BASE_TOKEN_URI, Strings.toString(tokenUriId));

    }


    
       /**
     * @param tokenUriId this is the id of the nft
     * @return it returns the full price of the nft
     * @dev it returns the price of the nft if it is set, however if it is not set, it should return the default price of the nft
     */

    function _priceOfNft(uint256 tokenUriId)internal view returns(uint256){
        uint256 nftPrice = nftIdToPrice[tokenUriId];
        if(nftPrice <= 0){
            return i_defaultNftPrice;
        }

        return nftPrice;
    }


    




    








    
    



}