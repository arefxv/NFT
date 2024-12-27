// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {BasicNft} from "src/BasicNft.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {MoodNft} from "src/MoodNft.sol";

contract MintBasicNft is Script {
    string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("BasicNft", block.chainid);
        mintOnContract(mostRecentlyDeployed);
    }

    function mintOnContract(address basicNftAddress) public {
        vm.startBroadcast();
        BasicNft(basicNftAddress).mintNft(PUG);
        vm.stopBroadcast();
    }
}

contract MintMoodNft is Script {
    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("MoodNft", block.chainid);
        mintMoodNftOnContract(mostRecentlyDeployed);
    }

    function mintMoodNftOnContract(address moodNftContractAddress) public {
        vm.startBroadcast();
        MoodNft(moodNftContractAddress).mintMoodNft();
        vm.stopBroadcast();
    }
}

contract FlipMoodNft is Script {
    uint256 public constant TOKEN_ID = 0;

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("MoodNft", block.chainid);
        flipOnContract(mostRecentlyDeployed);
    }

    function flipOnContract(address moodNftContractAddress) public {
        vm.startBroadcast();
        MoodNft(moodNftContractAddress).flipMood(TOKEN_ID);
        vm.stopBroadcast();
    }
}
