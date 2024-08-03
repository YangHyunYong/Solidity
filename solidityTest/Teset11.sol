// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
contract Test11{
    /*
    로또 프로그램을 만드려고 합니다. 
    숫자와 문자는 각각 4개 2개를 뽑습니다. 6개가 맞으면 1이더, 5개의 맞으면 0.75이더, 
    4개가 맞으면 0.25이더, 3개가 맞으면 0.1이더 2개 이하는 상금이 없습니다. 

    참가 금액은 0.05이더이다.

    예시 1 : 8,2,4,7,D,A
    예시 2 : 9,1,4,2,F,B
    */
    mapping(address=>string[6]) lottos;

    string[] numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];
    string[] alpha = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];

    function compareLotto(string[6] memory _arr) public {
        uint cnt;
        string[6] memory lotto=lottos[msg.sender];
        for(uint i=0;i<6;i++){
            for(uint j=0;j<6;j++){
                if(keccak256(abi.encodePacked(lotto[i]))==keccak256(abi.encodePacked(_arr[j]))){
                    cnt++;
                }
            }
        }

        if(cnt==6) payable(msg.sender).transfer(1 ether);
        else if(cnt==5) payable(msg.sender).transfer(0.75 ether);
        else if(cnt==4) payable(msg.sender).transfer(0.25 ether);
        else if(cnt==3) payable(msg.sender).transfer(0.1 ether);
    }

    function buyLotto() public payable {
        require(msg.value==0.05 ether,"Nope");

        string[6] memory temp;
        string memory select;
        uint[6] memory idxList;
        uint idx;
        for(uint i=0;i<6;i++){
            if(i<4){
                idx= uint(keccak256(abi.encodePacked(block.timestamp,block.prevrandao))) % numbers.length;
            }
            else{
                idx= uint(keccak256(abi.encodePacked(block.timestamp,block.prevrandao))) % alpha.length;
            }
            temp[i]=select;
        }
        lottos[msg.sender]=temp;
    }

    function get()public view returns(string[6] memory){
        return lottos[msg.sender];
    }

    function getRandom(string[] memory _arr) private view returns(string memory){
        uint idx = uint(keccak256(abi.encodePacked(block.timestamp,block.prevrandao))) % _arr.length;
        return _arr[idx];
    }
}