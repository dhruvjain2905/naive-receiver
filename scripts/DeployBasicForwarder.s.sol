// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import "lib/forge-std/src/Script.sol";
import {BasicForwarder} from "src/BasicForwarder.sol"; // Adjust this path to your folder structure

contract DeployBasicForwarder is Script {
    function run() external {
        // Start broadcasting the transaction
        vm.startBroadcast();

        // Deploy the BasicForwarder contract
        BasicForwarder forwarder = new BasicForwarder();

        // Log the deployed contract address
        console.log("BasicForwarder deployed at:", address(forwarder));

        // Stop broadcasting the transaction
        vm.stopBroadcast();
    }
}