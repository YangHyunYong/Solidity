// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Test9{
    /*
    흔히들 비밀번호 만들 때 대소문자 숫자가 각각 1개씩은 포함되어 있어야 한다 
    등의 조건이 붙는 경우가 있습니다. 그러한 조건을 구현하세요.

    입력값을 받으면 그 입력값 안에 대문자, 
    소문자 그리고 숫자가 최소한 1개씩은 포함되어 있는지 여부를 
    알려주는 함수를 구현하세요.
    */

    //비트마스크 사용
    function pwCheck(string memory _pw) public pure returns(uint){
        uint sign;
        for(uint i=0;i<bytes(_pw).length;i++){
            bytes1 pw = bytes(_pw)[i];

            if(pw >= bytes1(uint8(0+48)) && pw <= bytes1(uint8(9+48))){
                sign |= 1;
            }
            else if(pw>=bytes1("A") && pw<=bytes1("Z")){
                sign |= 2;
            }
            else if(pw>=bytes1("a") && pw<=bytes1("z")){
                sign |= 4;
            }
        }
        return sign;
    }
    
    //40을 두개 이상 방법으로 2진수로 표현해봐라 -> 절대 안된다 -> 숫자가 의미하는 바가 명확하다

}

contract Bitwise{
    //and
    function op1(uint a,uint b) public pure returns(uint){
        return a & b;
    }

    //or
    function op2_or(uint a,uint b) public pure returns(uint){
        return a | b;
    }

    //xor
    //erc-165
    function op3_xor(uint a,uint b) public pure returns(uint){
        return a ^ b;
    }

    function op4(uint a,uint b,uint c) public pure returns (uint,uint,uint){
        return (a&b&c, a|b|c, a^b^c);
    }

    function op5(uint a,uint b,uint c,uint d) public pure returns(uint){
        return (a^b^c^d);
    }
}