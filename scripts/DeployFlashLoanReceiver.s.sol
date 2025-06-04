// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import "lib/forge-std/src/Script.sol";
import {FlashLoanReceiver} from "src/FlashLoanReceiver.sol"; // Adjust path to actual location

contract DeployFlashLoanReceiver is Script {
    function run() external {
        // Replace with the actual deployed NaiveReceiverPool address
        address pool = 0xYourNaiveReceiverPoolAddressHere;

        vm.startBroadcast();

        FlashLoanReceiver receiver = new FlashLoanReceiver(pool);

        console.log("FlashLoanReceiver deployed at:", address(receiver));

        vm.stopBroadcast();
    }
}
