// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Q61{
    /*
    a의 b승을 반환하는 함수를 구현하세요.
    */   
    function power(uint _a,uint _b) public pure returns(uint){
        return _a**_b;
    }
}

contract Q62{
    /*
    2개의 숫자를 더하는 함수, 곱하는 함수 a의 b승을 반환하는 함수를 구현하는데 
    3개의 함수 모두 2개의 input값이 10을 넘지 않아야 하는 조건을 최대한 효율적으로 구현하세요.
    */
    modifier checkInput(uint _a, uint _b) {
        require(_a<=10 && _b<=10,"Nope");
        _;
    }

    function add(uint _a,uint _b) checkInput(_a,_b) public pure returns(uint){
        return _a+_b;
    }

    function mul(uint _a,uint _b) checkInput(_a,_b) public pure returns(uint){
        return _a*_b;
    }

    function power(uint _a,uint _b) checkInput(_a,_b) public pure returns(uint){
        return _a**_b;
    }
}

contract Q63{
    /*
    2개 숫자의 차를 나타내는 함수를 구현하세요.
    */
    function sub(uint _a,uint _b) public pure returns(uint){
        return _a>_b ? _a-_b : _b-_a;
    }
}

contract Q64{
    /*
    지갑 주소를 넣으면 5개의 4bytes로 분할하여 반환해주는 함수를 구현하세요.
    */
     function split(address _addr) public pure returns (bytes4[5] memory) {
        bytes20 addr = bytes20(_addr);
        bytes4[5] memory result;
        bytes4 temp;
        
        for(uint i=0;i<5;i++){
            temp=bytes4(abi.encodePacked(addr[i*4],addr[i*4+1],addr[i*4+2],addr[i*4+3]));
            result[i]=temp;
        }

        return result;
    }
}

contract Q65{
    /*
    숫자 3개를 입력하면 그 제곱을 반환하는 함수를 구현하세요. 
    그 3개 중에서 가운데 출력값만 반환하는 함수를 구현하세요.
    예) func A : input → 1,2,3 // output → 1,4,9 | func B : output 4 (1,4,9중 가운데 숫자)
    */
    function funcA(uint[] memory nums) public pure returns(uint[] memory){
        for(uint i=0;i<nums.length;i++){
            nums[i]= nums[i]**2;
        }
        return nums;
    }

    function funcB(uint[] memory nums) public pure returns(uint){
        for(uint i=0;i<nums.length;i++){
            for(uint j=i+1;j<nums.length;j++){
                if(nums[i]>nums[j]){
                    (nums[i],nums[j])=(nums[j],nums[i]);
                }
            }
        }
        return nums[1];
    }
}

contract Q66{
    /*
    특정 숫자를 입력했을 때 자릿수를 알려주는 함수를 구현하세요. 
    추가로 그 숫자를 5진수로 표현했을 때는 몇자리 숫자가 될 지 알려주는 함수도 구현하세요.
    */
    function getLength(uint _n) public pure returns (uint){
        uint len;
        while(_n>0){
            len++;
            _n/=10;
        }
        return len;
    }

    function getLength2(uint _n) public pure returns(uint){
        uint len;
        while(_n>0){
            len++;
            _n/=5;
        }
        return len;
    }
}

contract Q67_A{
    /*
    자신의 현재 잔고를 반환하는 함수를 보유한 Contract A와 
    다른 주소로 돈을 보낼 수 있는 Contract B를 구현하세요.
    B의 함수를 이용하여 A에게 전송하고 A의 잔고 변화를 확인하세요.
    */  
    receive() external payable {}

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

}
contract Q67_B{
    function sendEther(address _addr) public payable{
        payable(_addr).transfer(msg.value);
    }
}

contract Q68{
    /*
    계승(팩토리얼)을 구하는 함수를 구현하세요. 계승은 그 숫자와 같거나 작은 모든 수들을 곱한 값이다. 
    예) 5 → 1*2*3*4*5 = 120, 11 → 1*2*3*4*5*6*7*8*9*10*11 = 39916800
    while을 사용해보세요
    */
    function factorial(uint _n) public pure returns(uint){
        uint sum=1;
        while(_n>0){
            sum*=_n--;
        }
        return sum;
    }
}

import "@openzeppelin/contracts/utils/Strings.sol";
contract Q69{
    /*
    숫자 1,2,3을 넣으면 1 and 2 or 3 라고 반환해주는 함수를 구현하세요.
    힌트 : 7번 문제(시,분,초로 변환하기)
    */
    function func(uint _a, uint _b, uint _c) public pure returns(string memory){
        return string(abi.encodePacked(Strings.toString(_a), " and ", Strings.toString(_b)," or ",Strings.toString(_c)));
    }
}

contract Q70{
    /*
    번호와 이름 그리고 bytes로 구성된 고객이라는 구조체를 만드세요. 
    bytes는 번호와 이름을 keccak 함수의 input 값으로 넣어 나온 output값입니다. 
    고객의 정보를 넣고 변화시키는 함수를 구현하세요. 
    */
    struct Customer{
        uint number;
        string name;
        bytes encodeData;
    }

    Customer[] public customers;
    function setInfo(uint _number, string memory _name) public {
        customers.push(Customer(_number, _name, abi.encodePacked(keccak256(abi.encodePacked(_number, _name)))));
    }
}