// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Q31{
    /*
    string을 input으로 받는 함수를 구현하세요. "Alice"나 "Bob"일 때에만 true를 반환하세요.
    */
    function AliceOrBob(string memory _s) public pure returns(bool){
        if(keccak256(abi.encodePacked(_s))==keccak256(abi.encodePacked("Alice")) || keccak256(abi.encodePacked(_s))==keccak256(abi.encodePacked("Bob"))){
            return true;
        }
        return false;
    }
}

contract Q32{
    /*
    3의 배수만 들어갈 수 있는 array를 구현하되, 
    3의 배수이자 동시에 10의 배수이면 들어갈 수 없는 추가 조건도 구현하세요.
    */
    uint[] arr;
    function func(uint _n) public {
        require(_n%3==0 && _n%10!=0 ,"Nope");
        arr.push(_n);
    } 
}

contract Q33{
    /*
    이름, 번호, 지갑주소 그리고 생일을 담은 고객 구조체를 구현하세요. 
    고객의 정보를 넣는 함수와 고객의 이름으로 검색하면 해당 고객의 전체 정보를 반환하는 함수를 구현하세요.
    */
    struct Customer{
        string name;
        uint number;
        address addr;
        uint birth;
    }

    mapping(string => Customer) customers;
    
    function setInfo(Customer memory _c) public {
        customers[_c.name] = _c;
    }

    function getInfoByName(string memory _n) public view returns(Customer memory _c){
        _c=customers[_n];
    }
}

contract Q34{
    /*
    이름, 번호, 점수가 들어간 학생 구조체를 선언하세요. 
    학생들을 관리하는 자료구조도 따로 선언하고 학생들의 전체 평균을 계산하는 함수도 구현하세요.
    */
    struct Student{
        string name;
        uint number;
        uint score;
    }

    Student[] students;
    
    function getAvg() public view returns(uint){
        require(students.length>0,"Nope");
        uint sum;
        for(uint i=0;i<students.length;i++){
            sum+=students[i].score;
        }
        return sum/students.length;
    }
}

contract Q35{
    /*
    숫자만 들어갈 수 있는 array를 선언하고 
    해당 array의 짝수번째 요소만 모아서 반환하는 함수를 구현하세요.
    예) [1,2,3,4,5,6] -> [2,4,6] // [3,5,7,9,11,13] -> [5,9,13]
    */
    uint[] arr;

    function setArr(uint[] memory _a) public {
        arr=_a;
    }
    
    function getEvens() public view returns(uint[] memory){
        uint[] memory evens = new uint[](arr.length/2);
        uint idx=0;
        for(uint i=1;i<arr.length;i+=2){
            evens[idx++]=arr[i];
        }
        return evens;
    }
}

contract Q36{
    /*
    high, neutral, low 상태를 구현하세요. 
    a라는 변수의 값이 7이상이면 high, 4이상이면 neutral 
    그 이후면 low로 상태를 변경시켜주는 함수를 구현하세요.
    */
    string public status;
    
    function setStatus(uint a) public{
        if(a>=7) status="high";
        else if(a>=4) status="neutral";
        else status="low";
    }
}

contract Q37{
    /*
    1 wei를 기부하는 기능, 1finney를 기부하는 기능 그리고 1 ether를 기부하는 기능을 구현하세요. 
    최초의 배포자만이 해당 smart contract에서 자금을 회수할 수 있고 다른 이들은 못하게 막는 함수도 구현하세요.
    (힌트 : 기부는 EOA가 해당 Smart Contract에게 돈을 보내는 행위, contract가 돈을 받는 상황)
    */

    address payable owner;
    constructor(){
        owner = payable(msg.sender);
    }

    function donateWei() public payable  {
        require(msg.value == 1 wei,"Give 1 wei");
    }

    function donateFinney() public payable {
        require(msg.value == 0.001 ether,"Give 1 finney");
    }

    function donateEther() public payable {
        require(msg.value == 1 ether,"Give 1 ether");
    }

    function withdraw() public{
        require(msg.sender==owner,"Nope");
        owner.transfer(address(this).balance);
    }
}

contract Q38{
    /*
    상태변수 a를 "A"로 설정하여 선언하세요. 
    이 함수를 "B" 그리고 "C"로 변경시킬 수 있는 함수를 각각 구현하세요. 
    단 해당 함수들은 오직 owner만이 실행할 수 있습니다. 
    owner는 해당 컨트랙트의 최초 배포자입니다
    */
    string public a="A";
    address owner;

    constructor(){
        owner=msg.sender;
    }

    modifier isOwner(){
        require(msg.sender==owner,"Nope");
        _;
    }

    function setB() public isOwner {
        a="B";
    }
    function setC() public isOwner {
        a="C";
    }
}

contract Q39{
    /*
    특정 숫자의 자릿수까지의 2의 배수, 3의 배수, 5의 배수 7의 배수의 개수를 반환해주는 함수를 구현하세요.
    예) 15 : 7,5,3,2  (2의 배수 7개, 3의 배수 5개, 5의 배수 3개, 7의 배수 2개) 
    // 100 : 50,33,20,14  (2의 배수 50개, 3의 배수 33개, 5의 배수 20개, 7의 배수 14개)
    */
    function func(uint _n) public pure returns(uint,uint,uint,uint){
        return (_n/2,_n/3,_n/5,_n/7);
    }
}

contract Q40{
    /*
    숫자를 임의로 넣었을 때 내림차순으로 정렬하고 가장 가운데 있는 숫자를 반환하는 함수를 구현하세요. 
    가장 가운데가 없다면 가운데 2개 숫자를 반환하세요.
    예) [5,2,4,7,1] -> [1,2,4,5,7], 4 
    // [1,5,4,9,6,3,2,11] -> [1,2,3,4,5,6,9,11], 4,5 
    // [6,3,1,4,9,7,8] -> [1,3,4,6,7,8,9], 6
    */
    //예시가 오름차순 같습니다!
    function sort(uint[] memory _arr) public pure returns(uint[] memory,uint,uint){
        uint[] memory temp = _arr;
        for(uint i=0;i<_arr.length;i++){
            for(uint j=i+1;j<_arr.length;j++){
                if(temp[i]>temp[j]){
                    (temp[i],temp[j]) = (temp[j],temp[i]);
                }
            }
        }

        if(temp.length%2==0) return (temp,temp[temp.length/2-1],temp[temp.length/2]);
        else return (temp,temp[temp.length/2],0);
    } 
}