// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.6.6;
pragma experimental ABIEncoderV2;

import {Script, console2} from "forge-std/Script.sol";

contract ShadowScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
    }
}
