// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {MoodNft} from "src/MoodNft.sol";
import {Base64} from "@openzeppelin/utils/Base64.sol";

contract DeployMoodNft is Script {
    string public happySvg = vm.readFile("./img/happy.svg");
    string public sadSvg = vm.readFile("./img/sad.svg");

    function run() external returns (MoodNft) {
        vm.startBroadcast();
        MoodNft mood = new MoodNft(svgToImageUri(happySvg), svgToImageUri(sadSvg));
        vm.stopBroadcast();
        return mood;
    }

    function svgToImageUri(string memory svg) public pure returns (string memory) {
        string memory baseUri = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        return string(abi.encodePacked(baseUri, svgBase64Encoded));
    }
}
