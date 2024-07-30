// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
contract Test12{
    /*
    주차정산 프로그램을 만드세요. 주차시간 첫 2시간은 무료, 그 이후는 1분마다 200원(wei)씩 부과합니다. 
    주차료는 차량번호인식을 기반으로 실행됩니다.
    주차료는 주차장 이용을 종료할 때 부과됩니다.
    ----------------------------------------------------------------------
    차량번호가 숫자로만 이루어진 차량은 20% 할인해주세요.
    차량번호가 문자로만 이루어진 차량은 50% 할인해주세요.
    */
    mapping(string=>uint) parkInfo;

    function inOut(string memory _cn) public returns(uint){
        if(parkInfo[_cn]==0){
            parkInfo[_cn]=block.timestamp;
            return(0);
        }
        else{
            return checkCost(_cn);
        }
    }

    function checkCost(string memory _cn) view private returns(uint){
        uint cost;
        uint time=block.timestamp - parkInfo[_cn];
        if(time > 2 hours){
            time -= 2 hours;
            cost = time/(1 minutes) * 200 wei;
        }

        uint dis = discount(_cn);
        if(dis==2) cost -= cost*50/100;
        else if(dis==1) cost -= cost*20/100;

        return cost;
    }

    /*
    차량번호가 숫자로만 이루어진 차량은 20% 할인해주세요.
    차량번호가 문자로만 이루어진 차량은 50% 할인해주세요.
    */
    function discount(string memory _cn) private pure returns(uint){
        uint isNum;
        for(uint i=0;i<bytes(_cn).length;i++){
            bytes1 cn = bytes(_cn)[i];
            if(cn >= bytes1(uint8(0+48)) && cn <= bytes1(uint8(9+48))){
                isNum++;
            }
        }
        if(isNum==0) return 2;
        else if(isNum==bytes(_cn).length) return 1;
        else return 0;
    }
}