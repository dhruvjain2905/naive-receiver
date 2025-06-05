// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import "lib/forge-std/src/Script.sol";
import {NaiveReceiverPool} from "src/NaiveReceiverPool.sol";

contract DeployNaiveReceiverPool is Script {
    function run() external {
        // Provide these addresses before deploying
        address trustedForwarder = 0x1234567890123456789012345678901234567890;
        address payable weth = payable(0xABCDEFabcdefABCDEFabcdefABCDEFabcdefabcd);
        address feeReceiver = 0xFEEfEEfEEfEEfEEfEEfEEfEEfEEfEEfEEfEEfEEF;

        vm.startBroadcast();

        // You can send ETH along with deployment here, e.g. 10 ETH as pool liquidity
        NaiveReceiverPool pool = (new NaiveReceiverPool){value: 10 ether}(trustedForwarder, weth, feeReceiver);

        console.log("NaiveReceiverPool deployed at:", address(pool));

        vm.stopBroadcast();
    }
}
