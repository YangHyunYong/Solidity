// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Test7_s{
    enum CarStatus{
        stop,
        off,
        driving
    }

    struct Car{
        uint speed;
        uint gas;
        CarStatus status;
    }

    Car public myCar;

    function accel() public{
        require(myCar.speed<70 && myCar.gas>30 && (myCar.status==CarStatus.driving || myCar.status==CarStatus.stop),"Nope");
        myCar.speed+=10;
        myCar.gas-=20;
        if(myCar.status != CarStatus.driving) myCar.status=CarStatus.driving;
    }

    function Break() public{
        require(myCar.speed>0 && myCar.gas>=10,"Nope");
        myCar.speed-=10;
        myCar.gas-=10;
        if(myCar.speed==0) myCar.status=CarStatus.stop;
    }

    function turnOn() public{
        require(myCar.status == CarStatus.off,"Nope");
        myCar.status=CarStatus.stop;
    }

    function turnOff() public{
        require(myCar.status == CarStatus.stop,"Nope");
        myCar.status = CarStatus.off;
    }

    function charge() public payable {
        require((msg.value == 1 ether || address(this).balance >=1 ether) && myCar.status == CarStatus.off,"Nope");
        myCar.gas=100;
        payable(address(0x0)).transfer(1 ether);    //burn
        // (bool success, )=address(0).call{value: 1 ether}(""); //burn call버전
        // require(success);
    }

    receive() external payable { }
    // function pre() public payable{
        //오토모빌 관련해서 컨트랙트를 어떻게 합칠수있을까에 대한 아이디어 -> 각 차가 스마트컨트랙트를 한개씩 보유하고 있다 -> 운전습관, 현재 속도 규칙을 지키느냐를 로그로 기록해서 보험회사랑 연동해서 자동으로 안전운전점수 및 보험점수 평가까지 고려했었다
        //오라클 문제가 너무 심했고, 차가 달리는 속도를 어떻게 기록할까도 힘들었다
    // }
}

contract Test7{
    /*
    * 악셀 기능 - 속도를 10 올리는 기능, 악셀 기능을 이용할 때마다 연료가 20씩 줄어듬, 연료가 30이하면 더 이상 악셀을 이용할 수 없음, 속도가 70이상이면 악셀 기능은 더이상 못씀
    * 주유 기능 - 주유하는 기능, 주유를 하면 1eth를 지불해야하고 연료는 100이 됨
    * 브레이크 기능 - 속도를 10 줄이는 기능, 브레이크 기능을 이용할 때마다 연료가 10씩 줄어듬, 속도가 0이면 브레이크는 더이상 못씀
    * 시동 끄기 기능 - 시동을 끄는 기능, 속도가 0이 아니면 시동은 꺼질 수 없음
    * 시동 켜기 기능 - 시동을 켜는 기능, 시동을 키면 정지 상태로 설정됨
    --------------------------------------------------------
    * 충전식 기능 - 지불을 미리 해놓고 추후에 주유시 충전금액 차감 
    */
    uint public speed;
    uint public fuel;
    enum Status {
        Off,
        Stop,
        Drive
    }
    Status public status;

    mapping(address=>uint) users;

    function pressAccel() public {
        /*
        악셀 기능 - 속도를 10 올리는 기능, 악셀 기능을 이용할 때마다 연료가 20씩 줄어듬, 연료가 30이하면 더 이상 악셀을 이용할 수 없음, 속도가 70이상이면 악셀 기능은 더이상 못씀
        */
        require(speed<70 && fuel>30,"Nope");
        speed+=10;
        fuel-=20;
    }

    function refuel() public payable {
        /*
        * 주유 기능 - 주유하는 기능, 주유를 하면 1eth를 지불해야하고 연료는 100이 됨
        */    
        require(msg.value>=1 ether || users[msg.sender]>=1 ether,"Nope");

        if(msg.value<1 ether){
            users[msg.sender]-=1 ether;
        }
        
        fuel=100;
    }

    function pressBreak() public  {
        /*
        * 브레이크 기능 - 속도를 10 줄이는 기능, 브레이크 기능을 이용할 때마다 연료가 10씩 줄어듬, 속도가 0이면 브레이크는 더이상 못씀
        */
        require(speed>0,"Nope");
        speed-=10;
        fuel-=10;
    }

    function turnOff() public {
        /*
        * 시동 끄기 기능 - 시동을 끄는 기능, 속도가 0이 아니면 시동은 꺼질 수 없음
        */
        require(speed==0,"Nope");
        status= Status.Off;
        speed=0;
    }

    function turnOn() public {
        /*
        * 시동 켜기 기능 - 시동을 켜는 기능, 시동을 키면 정지 상태로 설정됨
        */
        status= Status.Stop;
    }

    function deposit() public payable {
        /*
        * 충전식 기능 - 지불을 미리 해놓고 추후에 주유시 충전금액 차감 
        */
        users[msg.sender]+=msg.value;
    }

    function getUser() public view returns(uint){
        return users[msg.sender];
    }
}