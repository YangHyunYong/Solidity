// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Q41{
    /*
    숫자만 들어갈 수 있으며 길이가 4인 배열을 (상태변수로)선언하고 
    그 배열에 숫자를 넣는 함수를 구현하세요. 배열을 초기화하는 함수도 구현하세요. 
    (길이가 4가 되면 자동으로 초기화하는 기능은 굳이 구현하지 않아도 됩니다.)
    */   
    uint[4] public arr;

    function reset() public {
        delete arr;
    }

    function addNum(uint _n) public {
        for(uint i=0;i<4;i++){
            if(arr[i]==0){
                arr[i]=_n;
                break;
            }
        }
    }

    //혹시 solidity에서도 이런식으로 break를 사용해도 괜찮은가요?
}

contract Q42{
    /*
    이름과 번호 그리고 지갑주소를 가진 '고객'이라는 구조체를 선언하세요. 
    새로운 고객 정보를 만들 수 있는 함수도 구현하되 이름의 글자가 최소 5글자가 되게 설정하세요.
    */
    struct Customer{
        string name;
        uint number;
        address addr;
    }
    mapping(address=>Customer) customers;

    function signUp(Customer memory _c) public {
        require(bytes(_c.name).length>=5,"Nope");
        customers[_c.addr] = _c;
    }
}

contract Q43{
    /*
    3. 은행의 역할을 하는 contract를 만드려고 합니다. 별도의 고객 등록 과정은 없습니다. 
    해당 contract에 ether를 예치할 수 있는 기능을 만드세요. 
    또한, 자신이 현재 얼마를 예치했는지도 볼 수 있는 함수 
    그리고 자신이 예치한만큼의 ether를 인출할 수 있는 기능을 구현하세요.
    힌트 : mapping을 꼭 이용하세요.
    */
    mapping(address => uint) users;

    function deposit() public payable {
        users[msg.sender] = msg.value;
    }

    function getBalance() public view returns(uint){
        return users[msg.sender];
    }

    function withdraw() public {
        payable(msg.sender).transfer(users[msg.sender]);
    }
}

contract Q44{
    /*
    string만 들어가는 array를 만들되, 4글자 이상인 문자열만 들어갈 수 있게 구현하세요.
    */
    string[] arr;
    function pushStr(string memory _s) public {
        require(bytes(_s).length>=4,"Nope");
        arr.push(_s);
    }
}

contract Q45{
    /*
    숫자만 들어가는 array를 만들되, 100이하의 숫자만 들어갈 수 있게 구현하세요.
    */
    uint[] arr;
    function pushNum(uint _n) public {
        require(_n<=100,"Nope");
        arr.push(_n);
    }
}

contract Q46{
    /*
    3의 배수이거나 10의 배수이면서 50보다 작은 수만 들어갈 수 있는 array를 구현하세요.
    (예 : 15 -> 가능, 3의 배수 
    // 40 -> 가능, 10의 배수이면서 50보다 작음 
    // 66 -> 가능, 3의 배수 
    // 70 -> 불가능 10의 배수이지만 50보다 큼)
    */
    uint[] arr;
    function pushNum(uint _n) public {
        require(_n%3==0 || (_n%10==0 && _n<50),"Nope");
        arr.push(_n);
    }
}

contract Q47{
    /*
    배포와 함께 배포자가 owner로 설정되게 하세요. 
    owner를 바꿀 수 있는 함수도 구현하되 그 함수는 owner만 실행할 수 있게 해주세요.
    */
    address owner;
    constructor(){
        owner = msg.sender;
    }

    function changeOwner(address to) public {
        require(msg.sender == owner,"Nope");
        owner = to;
    }
}

contract Q48_A{
    /*
    A라는 contract에는 2개의 숫자를 더해주는 함수를 구현하세요. 
    B라고 하는 contract를 따로 만든 후에 A의 더하기 함수를 사용하는 코드를 구현하세요.
    */
    function add(uint _a, uint _b) public pure returns(uint){
        return _a+_b;
    }
}
contract Q48_B{
    Q48_A ca = new Q48_A();

    function add(uint _a, uint _b) public view returns(uint){
        return ca.add(_a,_b);
    } 
}

contract Q49{
    /*
    긴 숫자를 넣었을 때, 마지막 3개의 숫자만 반환하는 함수를 구현하세요.
    예) 459273 → 273 // 492871 → 871 // 92218 → 218
    */
    // function getLastThree(uint _n) public pure returns(uint){
    //     uint idx=1;
    //     uint num;
    //     for(uint i=0;i<3;i++){
    //         num+=_n%10 * idx;
    //         idx*=10;
    //         _n/=10;
    //     }
    //     return num;
    // }
    function getLastThree(uint _n) public pure returns(uint){
        return _n%1000;
    }
}

contract Q50{
    /*
    숫자 3개가 부여되면 그 3개의 숫자를 이어붙여서 반환하는 함수를 구현하세요. 
    응용 문제 : 3개 아닌 n개의 숫자 이어붙이기
    예) 3,1,6 → 316 // 1,9,3 → 193 // 0,1,5 → 15 
    */
    function concatNum(uint[] memory nums) public pure returns(uint){
        uint sum;
        uint idx;
        for(uint i=nums.length;i>0;i--){
            sum+=nums[i-1] * 10 ** idx++;
        }
        return sum;
    }
}