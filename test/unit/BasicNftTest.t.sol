// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {BasicNft} from "src/BasicNft.sol";
import {DeployBasicNft} from "script/DeployBasicNft.s.sol";

contract BasicNftTest is Test {
    BasicNft public basicNft;
    DeployBasicNft public deployer;

    string public constant NAME = "Doggie";
    string public constant SYMBOL = "DOG";
    string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    uint256 public constant TOKEN_ID = 0;

    address USER = makeAddr("user");

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testInitializesWork() public view {
        assert(keccak256(abi.encodePacked(basicNft.name())) == keccak256(abi.encodePacked(NAME)));
        assert(keccak256(abi.encodePacked(basicNft.symbol())) == keccak256(abi.encodePacked(SYMBOL)));
    }

    function testUserCanMintAndHasBalance() public {
        vm.prank(USER);
        basicNft.mintNft(PUG);

        assert(basicNft.balanceOf(USER) == 1);
    }

    function testTokenUriWorks() public {
        vm.prank(USER);
        basicNft.mintNft(PUG);

        string memory tokenUri = basicNft.tokenURI(TOKEN_ID);

        assert(keccak256(abi.encodePacked(tokenUri)) == keccak256(abi.encodePacked(PUG)));
    }

    function testOneWillAddToTokenCounterWhenSomeoneMint() public {
        vm.prank(USER);
        basicNft.mintNft(PUG);

        uint256 expectedNumber = 1;
        uint256 actualNumber = basicNft.getTokenCounter();

        assert(expectedNumber == actualNumber);
    }
}
