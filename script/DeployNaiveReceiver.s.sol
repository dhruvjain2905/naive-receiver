// SPDX-License-Identifier: UNLICENSED
//pragma solidity ^0.8.25;

//import "lib/forge-std/src/Script.sol";
//import {BasicForwarder} from "src/BasicForwarder.sol"; 
//import {NaiveReceiverPool} from "../src/NaiveReceiverPool.sol";
//import {FlashLoanReceiver} from "../src/FlashLoanReceiver.sol";
//import {WETH} from "lib/solmate/src/tokens/WETH.sol";

//contract DeployNaiveReceiver is Script {
//    function run() external {
  //      vm.startBroadcast(); 

    //    BasicForwarder forwarder = new BasicForwarder();
    //    WETH weth = new WETH();
     //   address feeReceiver = msg.sender;

       // NaiveReceiverPool pool = new NaiveReceiverPool(
      //      address(forwarder),
      //      payable(address(weth)),
      //      feeReceiver
      //  );

      //  FlashLoanReceiver receiver = new FlashLoanReceiver(address(pool));

      //  console.log("BasicForwarder:", address(forwarder));
      //  console.log("WETH:", address(weth));
      //  console.log("NaiveReceiverPool:", address(pool));
       // console.log("FlashLoanReceiver:", address(receiver));
//
       // vm.stopBroadcast();
   // }
//#}

pragma solidity ^0.8.25;

import "forge-std/Script.sol";
import {BasicForwarder} from "src/BasicForwarder.sol"; 
import {NaiveReceiverPool} from "src/NaiveReceiverPool.sol";
import {FlashLoanReceiver} from "src/FlashLoanReceiver.sol";
import {WETH} from "lib/solmate/src/tokens/WETH.sol";

contract DeployNaiveReceiver is Script {
    // SET THIS TO YOUR WALLET ADDRESS
    address constant AGENT_ADDR = 0x4C1f023A2A914d109bEa600aB518f3078466e279; // <-- replace with your address

    // Amounts scaled down proportionally (1000x smaller)
    uint256 constant POOL_WETH_AMOUNT = 0.01 ether; // Scaled from 1000 WETH to 0.01 WETH
    uint256 constant RECEIVER_WETH_AMOUNT = 0.0001 ether; // Scaled from 10 WETH to 0.0001 WETH

    function run() external {
        // Load private key from environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        // Start broadcasting transactions from your deployer key
        vm.startBroadcast(deployerPrivateKey);

        // 1. Deploy all contracts
        BasicForwarder forwarder = new BasicForwarder();
        WETH weth = new WETH();
        address feeReceiver = 0xB3D455378ee5cb840e5bc9f399d399f2601c6d48;

        NaiveReceiverPool pool = new NaiveReceiverPool{value: POOL_WETH_AMOUNT}(
            address(forwarder),
            payable(address(weth)),
            feeReceiver
        );

        FlashLoanReceiver receiver = new FlashLoanReceiver(address(pool));

        // 2. Fund WETH for pool and receiver
        // Mint WETH by sending ETH to WETH contract (deposit)
        weth.deposit{value: RECEIVER_WETH_AMOUNT}();

        // Transfer WETH to pool
        //weth.transfer(address(pool), POOL_WETH_AMOUNT);

        // Transfer WETH to receiver
        weth.transfer(address(receiver), RECEIVER_WETH_AMOUNT);

        // 3. Log contract addresses with clear labels
        console.log("\n=== DEPLOYED CONTRACT ADDRESSES ===");
        console.log("BasicForwarder: %s", address(forwarder));
        console.log("WETH: %s", address(weth));
        console.log("NaiveReceiverPool: %s", address(pool));
        console.log("FlashLoanReceiver: %s", address(receiver));
        console.log("Agent (player) Address: %s", AGENT_ADDR);
        console.log("\n=== CONTRACT BALANCES ===");
        console.log("Pool WETH Balance: %s", weth.balanceOf(address(pool)));
        console.log("Receiver WETH Balance: %s", weth.balanceOf(address(receiver)));
        console.log("Agent WETH Balance: %s", weth.balanceOf(AGENT_ADDR));
        console.log("========================\n");

        vm.stopBroadcast();
    }

    // Allow the script to receive ETH for WETH deposit
    receive() external payable {}
}