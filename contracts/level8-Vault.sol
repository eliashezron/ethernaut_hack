// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// the goal of this contract is unlock the vault to bypass this level

contract Vault {
  bool public locked;
  bytes32 private password;

  constructor(bytes32 _password) {
    locked = true;
    password = _password;
  }

  function unlock(bytes32 _password) public {
    if (password == _password) {
      locked = false;
    }
  }
}
// solution
// to get the password. using web3.eth.getStorageAt method to get the item stored at a given location in the smart contract

web3.eth.getStorageAt(contract.address, 1) // would give us the info stored in slot 1 of the contract address. 
// then we can use it to unlock the vault