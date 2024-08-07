// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Q71{
    /*
    숫자형 변수 a를 선언하고 a를 바꿀 수 있는 함수를 구현하세요.
    한번 바꾸면 그로부터 10분동안은 못 바꾸게 하는 함수도 같이 구현하세요.
    */
    uint a;
    uint time=block.timestamp;

    function setA(uint _a) public {
        require(block.timestamp - time < 10 minutes,"Nope");
        time=block.timestamp;
        a=_a;
    }
}

contract Q72{
    /*
    contract에 돈을 넣을 수 있는 deposit 함수를 구현하세요. 
    해당 contract의 돈을 인출하는 함수도 구현하되 오직 owner만 할 수 있게 구현하세요. 
    owner는 배포와 동시에 배포자로 설정하십시오. 한번에 가장 많은 금액을 예치하면 owner는 바뀝니다.
    예) A (배포 직후 owner), B가 20 deposit(B가 owner), C가 10 deposit(B가 여전히 owner), D가 50 deposit(D가 owner), E가 20 deposit(D), E가 45 depoist(D), E가 65 deposit(E가 owner)
    */
    address owner;
    uint max;
    constructor(){
        owner=msg.sender;
    }

    function deposit() public payable virtual {
        if(max<msg.value) owner=msg.sender;
    }

    function withdraw() public {
        require(owner==msg.sender,"Nope");
        payable(msg.sender).transfer(address(this).balance);
    }
}

contract Q73 is Q72{
    /*
    위의 문제의 다른 버전입니다. 누적으로 가장 많이 예치하면 owner가 바뀌게 구현하세요.
    예) A (배포 직후 owner), B가 20 deposit(B가 owner), C가 10 deposit(B가 여전히 owner), D가 50 deposit(D가 owner), E가 20 deposit(D), E가 45 depoist(E가 owner, E 누적 65), E가 65 deposit(E)
    */
    mapping(address => uint) users;

    function deposit() public payable override {
        users[msg.sender]+=msg.value;
        if(users[owner]<users[msg.sender]){
            owner=msg.sender;
        }
    }
}

contract Q74 {
    /*
    어느 숫자를 넣으면 항상 10%를 추가로 더한 값을 반환하는 함수를 구현하세요.
    예) 20 -> 22(20 + 2, 2는 20의 10%), 0 // 50 -> 55(50+5, 5는 50의 10%), 0 
    // 42 -> 46(42+4), 4 (42의 10%는 4.2 -> 46.2, 46과 2를 분리해서 반환) 
    // 27 => 29(27+2), 7 (27의 10%는 2.7 -> 29.7, 29와 7을 분리해서 반환)
    */
    function addTen(uint _n) public pure returns(uint,uint){
        uint num=_n+_n*10;
        return (num/10,num%10);
    }
}

contract Q75{
    /*
    문자열을 넣으면 n번 반복하여 쓴 후에 반환하는 함수를 구현하세요.
    예) abc,3 -> abcabcabc // ab,5 -> ababababab
    */
    function repeat(string memory _s, uint _n) public pure returns(string memory){
        uint len=bytes(_s).length;

        bytes memory temp=new bytes(len * _n);

        uint idx;
        for(uint i=0;i<len*_n;i++){
            temp[i]=bytes(_s)[idx++];
            if(idx==len) idx=0;
        }
        return string(temp);
    }
}

contract Q76{
    /*
    숫자 123을 넣으면 문자 123으로 반환하는 함수를 직접 구현하세요. (패키지없이)
    */
    function convert(uint _n) public pure returns(string memory){
        uint n=_n;
        uint cnt;

        while(n>0){
            cnt++;
            n/=10;
        }
         
        if(_n==0) cnt=1;
        bytes memory temp = new bytes(cnt);
        
        for(uint i=cnt;i>0;i--){
            temp[i-1]=bytes1(uint8(_n%10+48));
            _n/=10;
        }
        return string(temp);
    }
}

import "@openzeppelin/contracts/utils/Strings.sol";
contract Q77{
    /*
    위의 문제와 비슷합니다. 이번에는 openzeppelin의 패키지를 import 하세요.
    힌트 : import "@openzeppelin/contracts/utils/Strings.sol";
    */
    function convert(uint _n) public pure returns(string memory){
        return Strings.toString(_n);
    }
}

contract Q78{
    /*
    숫자만 들어갈 수 있는 array를 선언하세요. 
    array 안 요소들 중 최소 하나는 10~25 사이에 있는지를 알려주는 함수를 구현하세요.
    예) [1,2,6,9,11,19] -> true (19는 10~25 사이) 
    // [1,9,3,6,2,8,9,39] -> false (어느 숫자도 10~25 사이에 없음)
    */
    uint[] arr;
    
    function setArr(uint[] memory _arr) public {
        arr=_arr;
    }

    function checkNum() public view returns(bool){
        bool check;
        for(uint i=0;i<arr.length;i++){
            if(arr[i]>=10 && arr[i]<=25){
                check=true;
                break;
            }
        }
        return check;
    }
}

//둘이 다른 위치에 있다고 생각하고 import 하기
// contract Q79_A{
//     /*
//     3개의 숫자를 넣으면 그 중에서 가장 큰 수를 찾아내주는 함수를 Contract A에 구현하세요. 
//     Contract B에서는 이름, 번호, 점수를 가진 구조체 학생을 구현하세요. 
//     학생의 정보를 3명 넣되 그 중에서 가장 높은 점수를 가진 학생을 반환하는 함수를 구현하세요. 
//     구현할 때는 Contract A를 import 하여 구현하세요.
//     */
//     function findMax(uint[] memory arr) public pure returns(uint){
//         uint max;
//         for(uint i=0;i<arr.length;i++){
//             if(max<arr[i]){
//                 max=arr[i];
//             }
//         }
//         return max;
//     }
// }
import "./Q79_A.sol";
contract Q79_B{
    struct Student{
        string name;
        uint number;
        uint score;
    }

    Q79_A ca = new Q79_A();
    function findStudent(Student[] memory _s) public view returns(Student memory _student){
        uint[] memory scores = new uint[](3);
        for(uint i=0;i<_s.length;i++){
            scores[i]=_s[i].score;
        }
        uint max = ca.findMax(scores);

        for(uint i=0;i<_s.length;i++){
            if(scores[i]==max) _student=_s[i];
        }
    }
}

//들어온 순서는 그대로. 나가는 순서는 반대로 바꾸기
contract Q80{
    /*
    지금은 동적 array에 값을 넣으면(push) 가장 앞부터 채워집니다. 1,2,3,4 순으로 넣으면 [1,2,3,4] 이렇게 표현됩니다. 
    그리고 값을 빼려고 하면(pop) 끝의 숫자부터 빠집니다. 가장 먼저 들어온 것이 가장 마지막에 나갑니다.
    이런 것들을FILO(First In Last Out)이라고도 합니다. 
    가장 먼저 들어온 것을 가장 먼저 나가는 방식을 FIFO(First In First Out)이라고 합니다. 
    push와 pop을 이용하되 FIFO 방식으로 바꾸어 보세요.
    */
    uint[] arr;

    function fifoPush(uint _n) public {
        arr.push(_n);
    }

    function fifoPop() public{
        uint[] memory temp = new uint[](arr.length-1);
        uint idx;
        for(uint i=arr.length;i>1;i--){
            temp[idx++]=arr[i-1];
        }
        delete arr;

        for(uint i=temp.length;i>0;i--){
            arr.push(temp[i-1]);
        }
    }

    // function fifoPush(uint _n) public {
    //     uint[] memory temp = new uint[](arr.length);
    //     if(arr.length==0){
    //         arr.push(_n);
    //     }
    //     else {
    //         uint len=arr.length;
    //         uint idx=0;
    //         while(len>0){
    //             temp[idx]=arr[arr.length-idx-1];
    //             idx++;
    //             len--;
    //         }
    //         delete arr;

    //         arr.push(_n);
    //         for(uint i=temp.length;i>0;i--){
    //             arr.push(temp[i-1]);
    //         }
    //     }
    // }

    // function fifoPop() public{
    //     arr.pop();
    // }

    function getArr() public view returns(uint[] memory){
        return arr;
    }
}