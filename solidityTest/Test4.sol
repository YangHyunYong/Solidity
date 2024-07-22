// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Test4 {
    /*
    간단한 게임이 있습니다.
    유저는 번호, 이름, 주소, 잔고, 점수를 포함한 구조체입니다. 
    참가할 때 참가비용 0.01ETH를 내야합니다. (payable 함수)
    4명까지만 들어올 수 있는 방이 있습니다. (array)
    선착순 4명에게는 각각 4,3,2,1점의 점수를 부여하고 4명이 되는 순간 방이 비워져야 합니다.

    예) 
    방 안 : "empty" 
    -- A 입장 --
    방 안 : A 
    -- B, D 입장 --
    방 안 : A , B , D 
    -- F 입장 --
    방 안 : A , B , D , F 
    A : 4점, B : 3점 , D : 2점 , F : 1점 부여 후 
    방 안 : "empty" 

    유저는 10점 단위로 점수를 0.1ETH만큼 변환시킬 수 있습니다.
    예) A : 12점 => A : 2점, 0.1ETH 수령 // B : 9점 => 1점 더 필요 // C : 25점 => 5점, 0.2ETH 수령

    * 유저 등록 기능 - 유저는 이름만 등록, 번호는 자동적으로 순차 증가, 주소도 자동으로 설정, 점수도 0으로 시작
    * 유저 조회 기능 - 유저의 전체정보 번호, 이름, 주소, 점수를 반환. 
    * 게임 참가시 참가비 제출 기능 - 참가시 0.01eth 지불 (돈은 smart contract가 보관)
    * 점수를 돈으로 바꾸는 기능 - 10점마다 0.1eth로 환전
    * 관리자 인출 기능 - 관리자는 0번지갑으로 배포와 동시에 설정해주세요, 관리자는 원할 때 전액 혹은 일부 금액을 인출할 수 있음 (따로 구현)
    ---------------------------------------------------------------------------------------------------
    * 예치 기능 - 게임할 때마다 참가비를 내지 말고 유저가 일정금액을 미리 예치하고 게임할 때마다 자동으로 차감시키는 기능.
    */

    struct User{
        uint number;
        string name;
        address addr;
        uint balance;
        uint score;
    }

    User[] users;
    User[4] players;
    mapping(address=>User) map;
    address payable owner;
    uint idx;

    constructor(){
        owner=payable(msg.sender);
    }

    function participate() public payable {
        /*
        게임 참가시 참가비 제출 기능 - 참가시 0.01eth 지불 (돈은 smart contract가 보관)
        선착순 4명에게는 각각 4,3,2,1점의 점수를 부여하고 4명이 되는 순간 방이 비워져야 합니다.
        */
        require(msg.value>=0.001 ether,"Need more than 0.01 ether");
        User memory user=map[msg.sender];
        players[idx++]=user;
        
        if(idx==4){
            for(uint i=0;i<4;i++){
                map[players[i].addr].score += 4-i;
            }

            delete players;
            idx=0;
        }
    }

    function signIn(string memory _name) public {
        /*
        유저 등록 기능 - 유저는 이름만 등록, 번호는 자동적으로 순차 증가, 주소도 자동으로 설정, 점수도 0으로 시작
        */
        require(owner!=msg.sender,"Owner cannot be user");
        User memory user=User(users.length+1,_name, msg.sender, 0,0);
        users.push(user);
        map[msg.sender] = user;
    }

    function getUsers() public view returns (User memory){
        /*
        유저 조회 기능 - 유저의 전체정보 번호, 이름, 주소, 점수를 반환
        */
        return map[msg.sender];
    }

    function transScoreToEther() public {
        /*
        점수를 돈으로 바꾸는 기능 - 10점마다 0.1eth로 환전
        */
        require(map[msg.sender].score>=10,"Need 10 scores");
        map[msg.sender].score-=10;
        payable(msg.sender).transfer(0.1 ether);
    }

    function withdrawAll() public {
        /*
        관리자 인출 기능 - 관리자는 0번지갑으로 배포와 동시에 설정해주세요, 
        관리자는 원할 때 전액 혹은 일부 금액을 인출할 수 있음 (따로 구현)
        */
        require(msg.sender == owner,"Not owner");
        owner.transfer(address(this).balance);
    }

    function withdrawSome(uint _balance) public {
        /*
        일부 금액을 인출할 수 있음 (따로 구현)
        */
        require(msg.sender == owner, "Not owner");
        require(_balance<=address(this).balance,"Not enough balance");
        owner.transfer(_balance * 1 ether);
    }
}


/* 풀이
contract Test4 {
    struct User{
        uint number;
        string name;
        address addr;
        uint balance;
        uint score; 
    }

    address payable owner;
    mapping(address => User) users;
    User[4] room;
    uint public idx=1;

    //이 컨트랙트는 돈이 들어가기도 하고 빠지기도 한다, owner 설정이 중요하다
    constructor(){
        owner = payable(msg.sender);
    }

    modifier onlyOwner {
        require(msg.sender == owner,"Not owner");
        _;
    }

    //돈을 빼 간 후에 2이더가 있어야된다
    modifier moreThanTwoEther {
        _;
        require(address(this).balance >= 2 ether,"Nope");
    }

    function withDraw(uint _n) public onlyOwner moreThanTwoEther{
        //0.01 이더 단위로 보내는거
        owner.transfer(_n * 0.01 ether);
    }

    function withdrawAll() public onlyOwner moreThanTwoEther{
        owner.transfer(address(this).balance);
    }

    //유저 등록 기능 - 유저는 이름만 등록, 번호는 자동적으로 순차 증가, 주소도 자동으로 설정, 점수도 0으로 시작
    function signIn(string memory _name) public {
        require(bytes(users[msg.sender].name).length==0,"Nope");
        users[msg.sender] = User(idx++, _name, msg.sender, 0, 0);
        //signin할때 이벤트 emit을 일으켜서 FE에서는 emit 발생마다 cnt를 센다, FE에서 idx값을 넣어줄 수 있음
    }

    function search(address _addr) public view returns(User memory){
        return users[_addr];
    }

    function join() public payable {
        require(bytes(users[msg.sender].name).length!=0 && (msg.value >= 0.01 ether || users[msg.sender].balance >= 0.01 ether), "Nope");

        //balance가 0.05 이상, msg.value를 0.001로 했음 
        
        if(msg.value<0.01 ether){
            users[msg.sender].balance -= 0.01 ether;
        }

        //0이 안되는 요소를 기준으로 idx 파악해라
        if(getLength()==3){
            room[3]=users[msg.sender];
            getScore(); //점수받기
            delete room;
        }
        else{
            room[getLength()] = users[msg.sender];
        }
    }

    function getScore() public {
        for(uint i=0;i<4;i++){
            //어떻게 가스비 효율적으로 만들까?
            users[room[i].addr].score += 4-i;
        }
    }

    //무조건 돈 주는걸 마지막에 해라, 점수를 줄이는걸 하고 돈을 줘라
    function withDrawTen() public {
        require(users[msg.sender].score >= 10,"Nope");
        users[msg.sender].score -= 10;
        payable(msg.sender).transfer(0.1 ether);
    }

    function withDrawN(uint _n) public {
        require(users[msg.sender].score >= _n,"Nope");
        users[msg.sender].score -= _n;
        payable(msg.sender).transfer(0.1 ether * (_n/10));
    }

    function withDrawMax() public {
        require(users[msg.sender].score >= 10,"Nope");

        // uint aScore = users[msg.sender].score/10 * 10;
        // users[msg.sender].score -= aScore;
        uint amount = users[msg.sender].score / 10;
        users[msg.sender].score %= 10;

        payable(msg.sender).transfer(0.1 ether * amount);
    }

    function deposit() public payable {
        users[msg.sender].balance += msg.value;
    }

    function getLength() public view returns(uint){
        for(uint i=0;i<4;i++){
            if(room[i].number==0) return i;
        }
        return 4;
    }

    //회원탈퇴를 하면 해당 번호가 없어진다 -> 그 번호를 땡길것인가, 번호를 두고 그 뒤에 걸로 할건가
    //빈번호에 넣을건가 그냥 두고 뒤에 추가할건가

    //mapping 있는 상태에서 idx를 그냥 넣었는데, for문을 돌려서 빈 idx가 있는지 추가
    //owner는 변경 시킬 수 있을까?

    //1. 크리티컬한건 owner가 게임 참가가 가능
    //2. owner가 돈을 다 빼간 상태에서 사람들이 게임에 들어왔음 -> 줄 돈이 없다 -> 어떻게 막을까
    //-> 돈을 얼마 이상 남아있게 한다(address(this)가 얼마인지 확인해서)
}
*/