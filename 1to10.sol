// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Q1{
    /*
    더하기, 빼기, 곱하기, 나누기 그리고 제곱을 반환받는 계산기를 만드세요.
    */
    uint public result;
    function add(uint _n) public{
        result += _n;
    }
    
    function sub(uint _n) public{
        result -= _n;
    }

    function mul(uint _n) public{
        result *= _n;
    }

    function div(uint _n) public{
        result /= _n;
    }

    function pow(uint _n) public{
        result = result ** _n;
    }
}