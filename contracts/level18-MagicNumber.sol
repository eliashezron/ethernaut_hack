// SPDX-License-Identifier: MIT

// provide the solution/solver. really tiny code. 10 opcodes only
// note, each opcode is 1byte
pragma solidity ^0.8.0;

contract MagicNum {

  address public solver;

  constructor() {}

  function setSolver(address _solver) public {
    solver = _solver;
  }

  /*
    ____________/\\\_______/\\\\\\\\\_____        
     __________/\\\\\_____/\\\///////\\\___       
      ________/\\\/\\\____\///______\//\\\__      
       ______/\\\/\/\\\______________/\\\/___     
        ____/\\\/__\/\\\___________/\\\//_____    
         __/\\\\\\\\\\\\\\\\_____/\\\//________   
          _\///////////\\\//____/\\\/___________  
           ___________\/\\\_____/\\\\\\\\\\\\\\\_ 
            ___________\///_____\///////////////__
  */
}

// We can now create the contract by noting the fact that a transaction sent to zero address (0x0) with some data is interpreted as Contract Creation by the EVM.

// initialization code + runtime code
// opcode = 600a600c600039600a6000f3 602a60505260206050f3

// txn = await web3.eth.sendTransaction({from: player, data: opcode)
// solverAddr = txn.contractAddress
// await contract.setSolver(solverAddr)

// send this to a zero address 
// or
contract hackContract{

    function run(address _target) external{
        bytes memory code = "\x60\x0a\x60\x0c\x60\x00\x39\x60\x0a\x60\x00\xf3\x60\x2a\x60\x80\x52\x60\x20\x60\x80\xf3";
        address solver;

        assembly {
            solver := create(0, add(code, 0x20), mload(code))
        }
        MagicNum(_target).setSolver(solver);
    }
}