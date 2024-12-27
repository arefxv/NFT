// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/access/Ownable.sol";
import {Base64} from "@openzeppelin/utils/Base64.sol";

/**
 * @title MoodNft
 * @dev ERC721 contract representing mood-changing NFTs.
 * Allows users to mint NFTs and toggle their mood state between HAPPY and SAD.
 * @author ArefXV
 */
contract MoodNft is ERC721, Ownable {
    // Custom error for unauthorized mood flips
    error MoodNft__OnlyOwnerCanFlipMood();

    /**
     * @dev Enumeration to define the two mood states.
     */
    enum NFTState {
        HAPPY,
        SAD
    }

    // Counter for tracking token IDs
    uint256 private s_tokenCounter;

    // URIs for SVG images representing each mood
    string private s_happySvgImgUri;
    string private s_sadSvgImgUri;

    // Mapping token IDs to their current mood state
    mapping(uint256 => NFTState) private s_tokenIdToState;

    // Event emitted when a new NFT is created
    event NFTcreated(uint256 indexed tokenId);

    /**
     * @dev Constructor to initialize contract state.
     * @param happySvgImgUri URI for the happy SVG image.
     * @param sadSvgImgUri URI for the sad SVG image.
     */
    constructor(string memory happySvgImgUri, string memory sadSvgImgUri)
        ERC721("MoodNft", "MOOD")
        Ownable(msg.sender)
    {
        s_tokenCounter = 0;
        s_happySvgImgUri = happySvgImgUri;
        s_sadSvgImgUri = sadSvgImgUri;
    }

    /**
     * @dev Mints a new Mood NFT to the caller.
     * Increments the token counter and assigns ownership.
     */
    function mintMoodNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
        emit NFTcreated(s_tokenCounter);
    }

    /**
     * @dev Toggles the mood state of an NFT.
     * Only the owner or an approved address can call this function.
     * @param tokenId The ID of the token to flip.
     */
    function flipMood(uint256 tokenId) public {
        if (getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender) {
            revert MoodNft__OnlyOwnerCanFlipMood();
        }

        if (s_tokenIdToState[tokenId] == NFTState.HAPPY) {
            s_tokenIdToState[tokenId] = NFTState.SAD;
        } else {
            s_tokenIdToState[tokenId] = NFTState.HAPPY;
        }
    }

    /**
     * @dev Returns the base URI for metadata.
     */
    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    /**
     * @dev Constructs and returns the metadata URI for a given token ID.
     * @param tokenId The ID of the token.
     */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI = s_happySvgImgUri;

        if (s_tokenIdToState[tokenId] == NFTState.SAD) {
            imageURI = s_sadSvgImgUri;
        }

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "',
                            name(),
                            '", "description": "An NFT that reflects its owner MOOD, 100% on-chain!" ',
                            '"attributes": [{"trait_type": "moodness", "value": 100}], "image": "',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    /**
     * @dev Returns the current token counter value.
     */
    function getTokenCounter() external view returns (uint256) {
        return s_tokenCounter;
    }

    /**
     * @dev Returns the URI of the happy mood SVG image.
     */
    function getHappySvgImgUri() external view returns (string memory) {
        return s_happySvgImgUri;
    }

    /**
     * @dev Returns the URI of the sad mood SVG image.
     */
    function getSadSvgImgUri() external view returns (string memory) {
        return s_sadSvgImgUri;
    }

    /**
     * @dev Returns the base URI used in metadata.
     */
    function getBaseUri() external pure returns (string memory) {
        return _baseURI();
    }
}
