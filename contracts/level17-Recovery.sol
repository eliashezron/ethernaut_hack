// SPDX-License-Identifier: MIT

// the goal of this contract is to recover of remove the 0.001 from the lost contract address
pragma solidity ^0.8.0;

contract Recovery {

  //generate tokens
  function generateToken(string memory _name, uint256 _initialSupply) public {
    new SimpleToken(_name, msg.sender, _initialSupply);
  
  }
}

contract SimpleToken {

  string public name;
  mapping (address => uint) public balances;

  // constructor
  constructor(string memory _name, address _creator, uint256 _initialSupply) {
    name = _name;
    balances[_creator] = _initialSupply;
  }

  // collect ether in return for tokens
  receive() external payable {
    balances[msg.sender] = msg.value * 10;
  }

  // allow transfers of tokens
  function transfer(address _to, uint _amount) public { 
    require(balances[msg.sender] >= _amount);
    balances[msg.sender] = balances[msg.sender] - _amount;
    balances[_to] = _amount;
  }

  // clean up after ourselves
  function destroy(address payable _to) public {
    selfdestruct(_to);
  }
}

// the goal here is to call the destroy function from the simple contract

// first, you get the function signature
// functionSignature = {
//     name: 'destroy',
//     type: 'function',
//     inputs: [
//         {
//             type: 'address',
//             name: '_to'
//         }
//     ]
// }

// params = [player]

// data = web3.eth.abi.encodeFunctionCall(functionSignature, params)

// // token address is the ddress of the simple token

// await web3.eth.sendTransaction({from: player, to: tokenAddr, data})

// or simply 
// simpleToken(_target).destroy()

