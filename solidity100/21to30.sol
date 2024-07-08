// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/utils/Arrays.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Q21{
    /*
    3의 배수만 들어갈 수 있는 array를 구현하세요.
    */
    uint[] arr;
    function addNum(uint _n) public {
        if(_n%3==0){
            arr.push(_n);
        }
    }
}

contract Q22{
    /*
    뺄셈 함수를 구현하세요. 
    임의의 두 숫자를 넣으면 자동으로 둘 중 큰수로부터 작은 수를 빼는 함수를 구현하세요.
    */
    function sub(uint _a, uint _b) public pure returns(uint){
        if(_a>_b){
            return _a-_b;
        }
        else{
            return _b-_a;
        }
    }
}

contract Q23{
    /*
    3의 배수라면 “A”를, 
    나머지가 1이 있다면 “B”를, 
    나머지가 2가 있다면 “C”를 반환하는 함수를 구현하세요.
    */
    function mod(uint _n) public pure returns(string memory){
        if(_n%3==1) return "B";
        else if(_n%3==2) return "C";
        else return "A";
    }
}

contract Q24{
    /*
    string을 input으로 받는 함수를 구현하세요. 
    “Alice”가 들어왔을 때에만 true를 반환하세요.
    */
    function isAlice(string memory _s) public pure returns(bool){
        if(keccak256(abi.encodePacked(_s)) == keccak256(abi.encodePacked("Alice"))){
            return true;
        }
        return false;
    }
}

contract Q25{
    /*
    배열 A를 선언하고 해당 배열에 n부터 0까지 자동으로 넣는 함수를 구현하세요. 
    */
    uint[] A;

    function setNum(int _n) public {
        for(int i=_n;i>=0;i--){
            A.push(uint(i));
        }
    }
}

contract Q26{
    /*
    홀수만 들어가는 array, 짝수만 들어가는 array를 구현하고 
    숫자를 넣었을 때 자동으로 홀,짝을 나누어 입력시키는 함수를 구현하세요.
    */
    uint[] odds;
    uint[] evens;

    function addNum(uint _n) public {
        if(_n%2==0) evens.push(_n);
        else odds.push(_n);
    }
}

contract Q27{
    /*
    string 과 bytes32를 key-value 쌍으로 묶어주는 mapping을 구현하세요. 
    해당 mapping에 정보를 넣고, 지우고 불러오는 함수도 같이 구현하세요.
    */
    mapping(string => bytes32) mapStringToBytes;

    function setMap(string memory _s, bytes32 _b) public {
        mapStringToBytes[_s]=_b;
    }

    function removeMap(string memory _s) public {
        delete mapStringToBytes[_s];
    }

    function getMap(string memory _s) public view returns(bytes32){
        return mapStringToBytes[_s];
    }
}

contract Q28{
    /*
    ID와 PW를 넣으면 해시함수(keccak256)에 둘을 같이 해시값을 반환해주는 함수를 구현하세요.
    */
    function encrypt(string memory _id, string memory _pw) public pure returns(bytes32){
        return(keccak256(abi.encodePacked(_id,_pw)));
    }
}

contract Q29{
    /*
    숫자형 변수 a와 문자형 변수 b를 각각 10 그리고 “A”의 값으로 배포 직후 설정하는 contract를 구현하세요.
    */
    uint a;
    string b;

    constructor(){
        (a,b) = (10,"A");
    }
}

contract Q30{
    /*
    임의대로 숫자를 넣으면 알아서 내림차순으로 정렬해주는 함수를 구현하세요
    */
    function sort(uint[] memory _numbers) public pure returns (uint[] memory){
        uint len=_numbers.length;
        for(uint i=0;i<len-1;i++){
            for(uint j=0;j<len-i-1;j++){
                if(_numbers[j]<_numbers[j+1]){
                    (_numbers[j],_numbers[j+1]) = (_numbers[j+1],_numbers[j]);
                }
            }
        }
        return _numbers;
    }
}