// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import "lib/forge-std/src/Script.sol";
import {BasicForwarder} from "src/BasicForwarder.sol"; 
import {NaiveReceiverPool} from "../src/NaiveReceiverPool.sol";
import {FlashLoanReceiver} from "../src/FlashLoanReceiver.sol";
import {WETH} from "lib/solmate/src/tokens/WETH.sol";

contract DeployNaiveReceiver is Script {
    function run() external {
        vm.startBroadcast(); 

        BasicForwarder forwarder = new BasicForwarder();
        WETH weth = new WETH();
        address feeReceiver = msg.sender;

        NaiveReceiverPool pool = new NaiveReceiverPool(
            address(forwarder),
            payable(address(weth)),
            feeReceiver
        );

        FlashLoanReceiver receiver = new FlashLoanReceiver(address(pool));

        console.log("BasicForwarder:", address(forwarder));
        //console.log("WETH:", address(weth));
        console.log("NaiveReceiverPool:", address(pool));
        console.log("FlashLoanReceiver:", address(receiver));

        vm.stopBroadcast();
    }
}