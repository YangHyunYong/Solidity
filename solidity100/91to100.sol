// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;


contract Q91 {
    /*
    배열에서 특정 요소를 없애는 함수를 구현하세요. 
    예) [4,3,2,1,8] 3번째를 없애고 싶음 → [4,3,1,8]
    */
    function remove(uint[] calldata _nums, uint _idx) public pure returns(uint[] memory){
        uint[] memory temp = new uint[](_nums.length-1);
        uint idx;
        for(uint i=0; i<_nums.length ;i++){
            if(i==_idx-1) continue;
            temp[idx++]=_nums[i];
        }
        return temp;
    }
}

contract Q92 {
    /*
    특정 주소를 받았을 때, 그 주소가 EOA인지 CA인지 감지하는 함수를 구현하세요.
    */
    function isEoa(address _addr) public view returns(string memory){
        if(_addr.code.length>0){
            return "CA";
        }
        return "EOA";
    }
}

contract Q93 {
    /*
    다른 컨트랙트의 함수를 사용해보려고 하는데, 그 함수의 이름은 모르고 methodId로 추정되는 값은 있다. 
    input 값도 uint256 1개, address 1개로 추정될 때 해당 함수를 활용하는 함수를 구현하세요.
    */
    function useCall(address _addr, bytes4 _methodId, uint _n, address _a) public {
        (bool success,)=_addr.call(abi.encodeWithSelector(_methodId, _n, _a));
        require(success);
    }
}

contract Q94 {
    /*
    inline - 더하기, 빼기, 곱하기, 나누기하는 함수를 구현하세요.
    */
    function add(uint _a, uint _b) public pure returns(uint _n){
        assembly{
            // _n:=add(_a,_b)
            let fmp := mload(0x40)
            mstore(fmp, add(_a,_b))
            _n := mload(fmp)
        }
    }

    function sub(uint _a, uint _b) public pure returns(uint _n){
        assembly{
            _n:=sub(_a,_b)
        }
    }

    function mul(uint _a, uint _b) public pure returns(uint _n){
        assembly{
            _n:=mul(_a,_b)
        }
    }

    function div(uint _a, uint _b) public pure returns(uint _n){
        assembly{
            _n:=div(_a,_b)
        }
    }
}

contract Q95 {
    /*
    inline - 3개의 값을 받아서, 더하기, 곱하기한 결과를 반환하는 함수를 구현하세요.
    */
    function add(uint _a, uint _b, uint _c) public pure returns(uint _n){
        assembly{
            let start := mload(0x40)
            mstore(start,add(add(_a,_b),_c))
            _n := mload(start)
        }
    }

    function mul(uint _a, uint _b, uint _c) public pure returns(uint _n){
        assembly{
            let start := mload(0x40)
            mstore(start,mul(mul(_a,_b),_c))
            _n := mload(start)
        }
    }
}

contract Q96 {
    /*
    inline - 4개의 숫자를 받아서 가장 큰수와 작은 수를 반환하는 함수를 구현하세요.
    */
    function getMaxMin(uint[4] memory arr) public pure returns(uint _max, uint _min){
        assembly{
            _max := 0
            _min := sub(exp(2,256),1)

            for {let i:=0} lt(i,4) {i:=add(i,1)} {
                let num := mload(add(arr,mul(0x20,i)))

                if lt(_max,num){
                    _max := num
                }
                if gt(_min,num){
                    _min := num
                }
            }
        }
    }
    //input을 uint[4] calldata arr로 하면 mload(arr) 시 0이 나오는데, inline으로 메모리에 접근한다면 그냥 input에 memory를 쓰는게 좋을까요?
}

contract Q97 {
    /*
    inline - 상태변수 숫자만 들어가는 동적 array numbers에 push하고 pop하는 함수 그리고 전체를 반환하는 구현하세요.
    */
    uint[] arr;
    function pushNum(uint _n) public {
        assembly{
            let len := sload(arr.slot)
            
            let nSlot := add(keccak256(0x0,0x20),len)
            sstore(nSlot, _n)
            sstore(arr.slot, add(len,1))
        }
    }  

    function popNum() public {
        assembly{
            let len := sload(arr.slot)
            if iszero(len) {revert(0,0)}
            
            let slot := add(keccak256(0x0,0x20),sub(len,1))
            sstore(slot,0)
            sstore(arr.slot, sub(len,1))
        }
    }

    function getArr() public view returns(uint[] memory _arr){
        assembly {
            let slot
            let len := sload(arr.slot)
            
            let mlen := mul(add(len,1),0x20)
            _arr := mload(0x40)
            mstore(0x40, add(_arr,mlen))
            
            mstore(_arr,len)
            let start := add(_arr,0x20)

            for{let i:=0} lt(i,len) {i:=add(i,1)}{
                slot := add(keccak256(0x0,0x20),i)
                mstore(add(start,mul(0x20,i)),sload(slot))
            }
        }
    }
}

contract Q98 {
    /*
    inline - 상태변수 문자형 letter에 값을 넣는 함수 setLetter를 구현하세요.
    */
    // string public letter;

    // function setLetter(string memory _s) public {
    //     assembly{
    //         let len := sload(letter.slot)

    //         let mlen := mload(_s)
    //         let data := add(_s,0x20)

    //         sstore(len, mlen)
    //         sstore(add(len,1),data)
    //         sstore(letter.slot,add(len,1))
    //     }   
    // }
}

contract Q99 {
    /*
    inline - 4개의 숫자를 받아서 가장 큰수와 작은 수를 반환하는 함수를 구현하세요.
    */
    function getMaxMin(uint[4] memory arr) public pure returns(uint _max, uint _min){
        assembly{
            _max := 0
            _min := sub(exp(2,256),1)

            for {let i:=0} lt(i,4) {i:=add(i,1)} {
                let num := mload(add(arr,mul(0x20,i)))

                if lt(_max,num){
                    _max := num
                }
                if gt(_min,num){
                    _min := num
                }
            }
        }
    }
}

contract Q100 {
    /*
    inline - 4개의 숫자를 받아서 가장 큰수와 작은 수를 반환하는 함수를 구현하세요.
    */
    function getMaxMin(uint[4] memory arr) public pure returns(uint _max, uint _min){
        assembly{
            _max := 0
            _min := sub(exp(2,256),1)

            for {let i:=0} lt(i,4) {i:=add(i,1)} {
                let num := mload(add(arr,mul(0x20,i)))

                if lt(_max,num){
                    _max := num
                }
                if gt(_min,num){
                    _min := num
                }
            }
        }
    }
}