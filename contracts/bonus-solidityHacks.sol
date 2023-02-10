// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// gas golf
contract GasGolf {
     // gas optimized
    // [1, 2, 3, 4, 5, 100]
    // start - 50860 gas
    // use calldata - 49115 gas
    // load state variables to memory - 48904 gas
    // short circuit - 48586 gas
    // loop increments - i++ = 48244 gas - ++1 = 48214 gas
    // cache array length - 48179 gas
    // load array elements to memory - 48017gas
    // function (++1)= 47603 gas, function (i++) = 47633 gass
    // uncheck i overflow/underflow - checked = 47297 gas, 

    uint public total;

    // start - not gas optimized
    function sumIfEvenAndLessThan99(uint[] calldata nums) external {
        uint _total = total;
        uint len = nums.length;
        for (uint i = 0; i < len;) {
            uint num = nums[i];
            if (num % 2 == 0 && num < 99) {
                _total += num;
            }
            unchecked {
                ++i;
            }
        }
        total = _total;
    }
    //Also wrapping the entire for loop in 'unchecked` can do the trick
    //  function unchecked_inc(uint i) internal pure returns(uint){
    //   unchecked {
    //     ++i;
    //   }
    //   return i;
    // }
}
