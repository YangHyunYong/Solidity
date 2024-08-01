// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Test13{
    /*
    가능한 모든 것을 inline assembly로 진행하시면 됩니다.
    

    */
    uint[] number;
    uint[4] number2;

    function get() public view returns(uint[] memory, uint[4] memory ){
        return (number,number2);
    }

    function func1(uint _n) public {
        /*
        1. 숫자들이 들어가는 동적 array number를 만들고 1~n까지 들어가는 함수를 만드세요.
        */
        assembly{
            let len := sload(number.slot)

            for{let i:=0} lt(i,_n) {i:=add(i,1)}{
                let slot := add(keccak256(add(number.slot,1),0x20),len)

                sstore(slot,add(i,1))

                len:=add(len,1)
                sstore(number.slot,len)
            }
        }
    }

    function func2(uint a, uint b, uint c, uint d) public {
        /*
        2. 숫자들이 들어가는 길이 4의 array number2를 만들고 여기에 4개의 숫자를 넣어주는 함수를 만드세요.
        */
        assembly{
            let slot := number2.slot
            sstore(add(slot, 0), a)
            sstore(add(slot, 1), b)
            sstore(add(slot, 2), c)
            sstore(add(slot, 3), d)
        }
    }

    function func3() public view returns(uint){
        /*
        3. number의 모든 요소들의 합을 반환하는 함수를 구현하세요. 
        */
        uint sum;
        assembly{
            let len := sload(number.slot)
            let start := add(len,1)
            for{let i:=0} lt(i,len) {i:=add(i,1)}{
                sum:=add(sum,sload(add(start,i)))
            }
        }
        return sum;
    }

    function func4() public view returns(uint){
        /*
        number2의 모든 요소들의 합을 반환하는 함수를 구현하세요. 
        */
        uint sum;
        assembly{
            sum:=0
            let slot := number2.slot
            
            for{let i :=0} lt(i,4) {i:=add(i,1)}{
                sum:=add(sum,sload(add(slot,i)))
            }
        }
        return sum;
    }

    function func5(uint _k) public view returns(uint){
        /*
        5. number의 k번째 요소를 반환하는 함수를 구현하세요.
        */
        uint num;
        assembly{
            let len := sload(number.slot)
            if iszero(lt(_k, len)) {revert(0,0)}

            let slot:=add(keccak256(add(number.slot,1),0x20), _k)
            num:=sload(slot)
        }  
        return num;
    }

    function func6(uint _k) public view returns(uint){
        /*
        6. number2의 k번째 요소를 반환하는 함수를 구현하세요.
        */
        uint num;
        assembly{
            let slot:=number2.slot
            num:=sload(add(slot,_k))
        }
        return num;
    }
    
}