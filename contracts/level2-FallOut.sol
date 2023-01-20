// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract Fallout {
  
  mapping (address => uint) allocations;
  address payable public owner;


  /* constructor */
  function Fal1out() public payable {
    owner = payable(msg.sender);
    allocations[owner] = msg.value;
  }

  modifier onlyOwner {
	        require(
	            msg.sender == owner,
	            "caller is not the owner"
	        );
	        _;
	    }

  function allocate() public payable {
    allocations[msg.sender] = msg.value;
  }

  function sendAllocation(address payable allocator) public {
    require(allocations[allocator] > 0);
    allocator.transfer(allocations[allocator]);
  }

  function collectAllocations() public onlyOwner {
    payable(msg.sender).transfer(address(this).balance);
  }

  function allocatorBalance(address allocator) public view returns (uint) {
    return allocations[allocator];
  }
}

// this was something about older versions of solidity that allowed a user use the contract name to declare the constructor, however, with new versions of solidity. the keyWord"contructor has to be used"
// even so, since the contructor wasnt declared as what was ment to be the declaration was mis-splet. calling the Fal1out() function gives us ownership rights to the contract.