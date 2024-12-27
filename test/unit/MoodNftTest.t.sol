// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {MoodNft} from "src/MoodNft.sol";
import {DeployMoodNft} from "script/DeployMoodNft.s.sol";
import {Vm} from "forge-std/Vm.sol";

contract MoodNftTest is Test {
    MoodNft public mood;
    DeployMoodNft public deployer;

    uint256 public constant TOKEN_ID = 0;
    string public constant NAME = "MoodNft";
    string public constant SYMBOL = "MOOD";
    string public constant HAPPY_IMG_URI =
        "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgaGVpZ2h0PSI0MDAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgPGNpcmNsZSBjeD0iMTAwIiBjeT0iMTAwIiBmaWxsPSJ5ZWxsb3ciIHI9Ijc4IiBzdHJva2U9ImJsYWNrIiBzdHJva2Utd2lkdGg9IjMiIC8+CiAgPGcgY2xhc3M9ImV5ZXMiPgogICAgPGNpcmNsZSBjeD0iNzAiIGN5PSI4MiIgcj0iMTIiIC8+CiAgICA8Y2lyY2xlIGN4PSIxMjciIGN5PSI4MiIgcj0iMTIiIC8+CiAgPC9nPgogIDxwYXRoIGQ9Im0xMzYuODEgMTE2LjUzYy42OSAyNi4xNy02NC4xMSA0Mi04MS41Mi0uNzMiIHN0eWxlPSJmaWxsOm5vbmU7IHN0cm9rZTogYmxhY2s7IHN0cm9rZS13aWR0aDogMzsiIC8+Cjwvc3ZnPg==";
    string public constant SAD_IMG_URI =
        "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAyNHB4IiBoZWlnaHQ9IjEwMjRweCIgdmlld0JveD0iMCAwIDEwMjQgMTAyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KICAgIDxwYXRoIGZpbGw9IiMzMzMiCiAgICAgICAgZD0iTTUxMiA2NEMyNjQuNiA2NCA2NCAyNjQuNiA2NCA1MTJzMjAwLjYgNDQ4IDQ0OCA0NDggNDQ4LTIwMC42IDQ0OC00NDhTNzU5LjQgNjQgNTEyIDY0em0wIDgyMGMtMjA1LjQgMC0zNzItMTY2LjYtMzcyLTM3MnMxNjYuNi0zNzIgMzcyLTM3MiAzNzIgMTY2LjYgMzcyIDM3Mi0xNjYuNiAzNzItMzcyIDM3MnoiIC8+CiAgICA8cGF0aCBmaWxsPSIjRTZFNkU2IgogICAgICAgIGQ9Ik01MTIgMTQwYy0yMDUuNCAwLTM3MiAxNjYuNi0zNzIgMzcyczE2Ni42IDM3MiAzNzIgMzcyIDM3Mi0xNjYuNiAzNzItMzcyLTE2Ni42LTM3Mi0zNzItMzcyek0yODggNDIxYTQ4LjAxIDQ4LjAxIDAgMCAxIDk2IDAgNDguMDEgNDguMDEgMCAwIDEtOTYgMHptMzc2IDI3MmgtNDguMWMtNC4yIDAtNy44LTMuMi04LjEtNy40QzYwNCA2MzYuMSA1NjIuNSA1OTcgNTEyIDU5N3MtOTIuMSAzOS4xLTk1LjggODguNmMtLjMgNC4yLTMuOSA3LjQtOC4xIDcuNEgzNjBhOCA4IDAgMCAxLTgtOC40YzQuNC04NC4zIDc0LjUtMTUxLjYgMTYwLTE1MS42czE1NS42IDY3LjMgMTYwIDE1MS42YTggOCAwIDAgMS04IDguNHptMjQtMjI0YTQ4LjAxIDQ4LjAxIDAgMCAxIDAtOTYgNDguMDEgNDguMDEgMCAwIDEgMCA5NnoiIC8+CiAgICA8cGF0aCBmaWxsPSIjMzMzIgogICAgICAgIGQ9Ik0yODggNDIxYTQ4IDQ4IDAgMSAwIDk2IDAgNDggNDggMCAxIDAtOTYgMHptMjI0IDExMmMtODUuNSAwLTE1NS42IDY3LjMtMTYwIDE1MS42YTggOCAwIDAgMCA4IDguNGg0OC4xYzQuMiAwIDcuOC0zLjIgOC4xLTcuNCAzLjctNDkuNSA0NS4zLTg4LjYgOTUuOC04OC42czkyIDM5LjEgOTUuOCA4OC42Yy4zIDQuMiAzLjkgNy40IDguMSA3LjRINjY0YTggOCAwIDAgMCA4LTguNEM2NjcuNiA2MDAuMyA1OTcuNSA1MzMgNTEyIDUzM3ptMTI4LTExMmE0OCA0OCAwIDEgMCA5NiAwIDQ4IDQ4IDAgMSAwLTk2IDB6IiAvPgo8L3N2Zz4=";
    string public constant BASE_URI = "data:application/json;base64,";
    string public constant HAPPY_TOKEN_URI =
        "data:application/json;base64,eyJuYW1lIjogIk1vb2ROZnQiLCAiZGVzY3JpcHRpb24iOiAiQW4gTkZUIHRoYXQgcmVmbGVjdHMgaXRzIG93bmVyIE1PT0QsIDEwMCUgb24tY2hhaW4hIiAiYXR0cmlidXRlcyI6IFt7InRyYWl0X3R5cGUiOiAibW9vZG5lc3MiLCAidmFsdWUiOiAxMDB9XSwgImltYWdlIjogImRhdGE6aW1hZ2Uvc3ZnK3htbDtiYXNlNjQsUEhOMlp5QjJhV1YzUW05NFBTSXdJREFnTWpBd0lESXdNQ0lnZDJsa2RHZzlJalF3TUNJZ2FHVnBaMmgwUFNJME1EQWlJSGh0Ykc1elBTSm9kSFJ3T2k4dmQzZDNMbmN6TG05eVp5OHlNREF3TDNOMlp5SStDaUFnUEdOcGNtTnNaU0JqZUQwaU1UQXdJaUJqZVQwaU1UQXdJaUJtYVd4c1BTSjVaV3hzYjNjaUlISTlJamM0SWlCemRISnZhMlU5SW1Kc1lXTnJJaUJ6ZEhKdmEyVXRkMmxrZEdnOUlqTWlJQzgrQ2lBZ1BHY2dZMnhoYzNNOUltVjVaWE1pUGdvZ0lDQWdQR05wY21Oc1pTQmplRDBpTnpBaUlHTjVQU0k0TWlJZ2NqMGlNVElpSUM4K0NpQWdJQ0E4WTJseVkyeGxJR040UFNJeE1qY2lJR041UFNJNE1pSWdjajBpTVRJaUlDOCtDaUFnUEM5blBnb2dJRHh3WVhSb0lHUTlJbTB4TXpZdU9ERWdNVEUyTGpVell5NDJPU0F5Tmk0eE55MDJOQzR4TVNBME1pMDRNUzQxTWkwdU56TWlJSE4wZVd4bFBTSm1hV3hzT201dmJtVTdJSE4wY205clpUb2dZbXhoWTJzN0lITjBjbTlyWlMxM2FXUjBhRG9nTXpzaUlDOCtDand2YzNablBnPT0ifQ==";
    string public constant SAD_TOKEN_URI =
        "data:application/json;base64,eyJuYW1lIjogIk1vb2ROZnQiLCAiZGVzY3JpcHRpb24iOiAiQW4gTkZUIHRoYXQgcmVmbGVjdHMgaXRzIG93bmVyIE1PT0QsIDEwMCUgb24tY2hhaW4hIiAiYXR0cmlidXRlcyI6IFt7InRyYWl0X3R5cGUiOiAibW9vZG5lc3MiLCAidmFsdWUiOiAxMDB9XSwgImltYWdlIjogImRhdGE6aW1hZ2Uvc3ZnK3htbDtiYXNlNjQsUEhOMlp5QjNhV1IwYUQwaU1UQXlOSEI0SWlCb1pXbG5hSFE5SWpFd01qUndlQ0lnZG1sbGQwSnZlRDBpTUNBd0lERXdNalFnTVRBeU5DSWdlRzFzYm5NOUltaDBkSEE2THk5M2QzY3Vkek11YjNKbkx6SXdNREF2YzNabklqNEtJQ0FnSUR4d1lYUm9JR1pwYkd3OUlpTXpNek1pQ2lBZ0lDQWdJQ0FnWkQwaVRUVXhNaUEyTkVNeU5qUXVOaUEyTkNBMk5DQXlOalF1TmlBMk5DQTFNVEp6TWpBd0xqWWdORFE0SURRME9DQTBORGdnTkRRNExUSXdNQzQySURRME9DMDBORGhUTnpVNUxqUWdOalFnTlRFeUlEWTBlbTB3SURneU1HTXRNakExTGpRZ01DMHpOekl0TVRZMkxqWXRNemN5TFRNM01uTXhOall1Tmkwek56SWdNemN5TFRNM01pQXpOeklnTVRZMkxqWWdNemN5SURNM01pMHhOall1TmlBek56SXRNemN5SURNM01ub2lJQzgrQ2lBZ0lDQThjR0YwYUNCbWFXeHNQU0lqUlRaRk5rVTJJZ29nSUNBZ0lDQWdJR1E5SWswMU1USWdNVFF3WXkweU1EVXVOQ0F3TFRNM01pQXhOall1Tmkwek56SWdNemN5Y3pFMk5pNDJJRE0zTWlBek56SWdNemN5SURNM01pMHhOall1TmlBek56SXRNemN5TFRFMk5pNDJMVE0zTWkwek56SXRNemN5ZWsweU9EZ2dOREl4WVRRNExqQXhJRFE0TGpBeElEQWdNQ0F4SURrMklEQWdORGd1TURFZ05EZ3VNREVnTUNBd0lERXRPVFlnTUhwdE16YzJJREkzTW1ndE5EZ3VNV010TkM0eUlEQXROeTQ0TFRNdU1pMDRMakV0Tnk0MFF6WXdOQ0EyTXpZdU1TQTFOakl1TlNBMU9UY2dOVEV5SURVNU4zTXRPVEl1TVNBek9TNHhMVGsxTGpnZ09EZ3VObU10TGpNZ05DNHlMVE11T1NBM0xqUXRPQzR4SURjdU5FZ3pOakJoT0NBNElEQWdNQ0F4TFRndE9DNDBZelF1TkMwNE5DNHpJRGMwTGpVdE1UVXhMallnTVRZd0xURTFNUzQyY3pFMU5TNDJJRFkzTGpNZ01UWXdJREUxTVM0MllUZ2dPQ0F3SURBZ01TMDRJRGd1TkhwdE1qUXRNakkwWVRRNExqQXhJRFE0TGpBeElEQWdNQ0F4SURBdE9UWWdORGd1TURFZ05EZ3VNREVnTUNBd0lERWdNQ0E1Tm5vaUlDOCtDaUFnSUNBOGNHRjBhQ0JtYVd4c1BTSWpNek16SWdvZ0lDQWdJQ0FnSUdROUlrMHlPRGdnTkRJeFlUUTRJRFE0SURBZ01TQXdJRGsySURBZ05EZ2dORGdnTUNBeElEQXRPVFlnTUhwdE1qSTBJREV4TW1NdE9EVXVOU0F3TFRFMU5TNDJJRFkzTGpNdE1UWXdJREUxTVM0MllUZ2dPQ0F3SURBZ01DQTRJRGd1TkdnME9DNHhZelF1TWlBd0lEY3VPQzB6TGpJZ09DNHhMVGN1TkNBekxqY3RORGt1TlNBME5TNHpMVGc0TGpZZ09UVXVPQzA0T0M0MmN6a3lJRE01TGpFZ09UVXVPQ0E0T0M0Mll5NHpJRFF1TWlBekxqa2dOeTQwSURndU1TQTNMalJJTmpZMFlUZ2dPQ0F3SURBZ01DQTRMVGd1TkVNMk5qY3VOaUEyTURBdU15QTFPVGN1TlNBMU16TWdOVEV5SURVek0zcHRNVEk0TFRFeE1tRTBPQ0EwT0NBd0lERWdNQ0E1TmlBd0lEUTRJRFE0SURBZ01TQXdMVGsySURCNklpQXZQZ284TDNOMlp6ND0ifQ==";
    address USER = makeAddr("user");

    event NFTcreated(uint256 indexed tokenId);

    function setUp() public {
        deployer = new DeployMoodNft();
        mood = deployer.run();
    }

    function testInitializesAreCorrect() public view {
        string memory expectedHappyImgUri = HAPPY_IMG_URI;
        string memory actualHappyImgUri = mood.getHappySvgImgUri();

        string memory expectedSadImgUri = SAD_IMG_URI;
        string memory actualSadImgUri = mood.getSadSvgImgUri();

        string memory expectedName = NAME;
        string memory actualName = mood.name();

        string memory expectedSymbol = SYMBOL;
        string memory actualSymbol = mood.symbol();

        uint256 expectedNumberOfTokens = 0;
        uint256 actualNumberOfTokens = mood.getTokenCounter();

        assert(keccak256(abi.encodePacked(expectedHappyImgUri)) == keccak256(abi.encodePacked(actualHappyImgUri)));
        assert(keccak256(abi.encodePacked(expectedSadImgUri)) == keccak256(abi.encodePacked(actualSadImgUri)));
        assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName)));
        assert(keccak256(abi.encodePacked(expectedSymbol)) == keccak256(abi.encodePacked(actualSymbol)));
        assert(expectedNumberOfTokens == actualNumberOfTokens);
    }

    modifier NFTminted() {
        vm.prank(USER);
        mood.mintMoodNft();
        _;
    }

    function testUserCanMintMoodNftAndHasBalance() public NFTminted {
        assert(mood.balanceOf(USER) == 1);
    }

    function testTokenCounterAddsWhenUserMintsAnNft() public NFTminted {
        uint256 expectedNumber = 1;
        uint256 actualNumber = mood.getTokenCounter();

        assert(actualNumber == expectedNumber);
    }

    function testFlipMoodRevertsIfNotOwner() public NFTminted {
        vm.expectRevert();
        mood.flipMood(TOKEN_ID);
    }

    function testUserCanFlipMood() public NFTminted {
        vm.prank(USER);
        mood.flipMood(TOKEN_ID);
    }

    function testFlipMoodToHappy() public NFTminted {
        vm.prank(USER);
        mood.flipMood(TOKEN_ID);

        vm.prank(USER);
        mood.flipMood(TOKEN_ID);
    }

    function testBaseUriReturnsCorrectString() public view {
        string memory actualUri = mood.getBaseUri();
        assert(keccak256(abi.encodePacked(actualUri)) == keccak256(abi.encodePacked(BASE_URI)));
    }

    function testTokenUriReturnsCorrectHappyUri() public NFTminted {
        string memory actualHappyTokenUri = mood.tokenURI(TOKEN_ID);

        assert(keccak256(abi.encodePacked(actualHappyTokenUri)) == keccak256(abi.encodePacked(HAPPY_TOKEN_URI)));
    }

    function testTokenUriReturnsCorrectSadUri() public NFTminted {
        vm.prank(USER);
        mood.flipMood(TOKEN_ID);

        string memory actualSadTokenUri = mood.tokenURI(TOKEN_ID);

        assert(keccak256(abi.encodePacked(actualSadTokenUri)) == keccak256(abi.encodePacked(SAD_TOKEN_URI)));
    }

    function testGetHappyAndSadSvgImgUrisWork() public view {
        string memory actualHappySvgImgUri = mood.getHappySvgImgUri();
        string memory actualSadSvgImgUri = mood.getSadSvgImgUri();

        assert(keccak256(abi.encodePacked(actualHappySvgImgUri)) == keccak256(abi.encodePacked(HAPPY_IMG_URI)));
        assert(keccak256(abi.encodePacked(actualSadSvgImgUri)) == keccak256(abi.encodePacked(SAD_IMG_URI)));
    }
}
