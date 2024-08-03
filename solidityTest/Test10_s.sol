// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
contract Test10_s{
    /*
    유저는 eoa, 은행은 여러개,국세청만 1개 CA
    Bank가 생성될때 국세청에 자동추가 기능 넣어보기

    은행에 관련된 어플리케이션을 만드세요.
    은행은 여러가지가 있고, 유저는 원하는 은행에 넣을 수 있다. 
    국세청은 은행들을 관리하고 있고, 세금을 징수할 수 있다. 
    세금은 간단하게 전체 보유자산의 1%를 징수한다. 세금을 자발적으로 납부하지 않으면 강제징수한다. 

    * 회원 가입 기능 - 사용자가 은행에서 회원가입하는 기능
    * 입금 기능 - 사용자가 자신이 원하는 은행에 가서 입금하는 기능
    * 출금 기능 - 사용자가 자신이 원하는 은행에 가서 출금하는 기능
    * 은행간 송금 기능 1 - 사용자의 A 은행에서 B 은행으로 자금 이동 (자금의 주인만 가능하게)
    * 은행간 송금 기능 2 - 사용자 1의 A 은행에서 사용자 2의 B 은행으로 자금 이동
    * 세금 징수 - 국세청은 주기적으로 사용자들의 자금을 파악하고 전체 보유량의 1%를 징수함. 세금 납부는 유저가 자율적으로 실행. (납부 후에는 납부 해야할 잔여 금액 0으로)
    -------------------------------------------------------------------------------------------------
    * 은행간 송금 기능 수수료 - 사용자 1의 A 은행에서 사용자 2의 B 은행으로 자금 이동할 때 A 은행은 그 대가로 사용자 1로부터 1 finney 만큼 수수료 징수.
    * 세금 강제 징수 - 국세청에게 사용자가 자발적으로 세금을 납부하지 않으면 강제 징수. 은행에 있는 사용자의 자금이 국세청으로 강제 이동
    */
}

contract IRS{
    //IRS 자체가 Bank를 만드는 방법도 있고 Bank가 생성될때 IRS에 자동추가하는 방법도 있다
    address[] bankList;

    function pushList(address _addr) public {
        bankList.push(_addr);
    }

    function getList() public view returns(address[] memory){
        return bankList;
    }

    function predict() public view returns(uint){
        uint sum;
        for(uint i=0;i<bankList.length;i++){
            sum+=Bank(payable(bankList[i])).getUser(msg.sender).balance;
        }
        return sum/100;
    }

    //얼만큼 받아야하는지, 냈는지 안냈는지, 그걸 IRS가 가지고 있을지 bank가 가지고 있을지를 생각해야한다
    function payTaxes() public payable{
        uint c;
        for(uint i=0;i<bankList.length;i++){
            (, , c)=Bank(payable(bankList[i])).users(msg.sender);
            if(c!=0) break;
        }

        //10일부터 16일 -> 다음 세금 내야되는 기간은 24일부터 30일
        //범위가 달라지는 모순점이 존재하긴함
        require(c+7 days <= block.timestamp);
        require(msg.value == predict(),"nope_tax");

        //paid 갱신
        for(uint i=0;i<bankList.length;i++){
            Bank(payable(bankList[i])).setTime(msg.sender,block.timestamp);
        }
    }
}

contract Bank{
    struct User{
        address addr;
        uint balance;
        uint paid;  
        //다양한곳, a/b뱅크가 똑같으니까 paid를 bank에 넘길 필요가 없다, IRS에서 가져와서 하는게 맞다
    }

    receive() external payable{}
    
    constructor(address _addr){
        // IRS(_addr).pushList(address(this));
        (bool success, ) = _addr.call(abi.encodeWithSignature("pushList(address)", address(this)));
        require(success);
    }

    mapping(address=>User) public users;

    function getUser(address _addr) public view returns(User memory){
        return users[_addr];
    }

    function signUp() public {
        users[msg.sender]=User(msg.sender,0,1);
    }

    function deposit() public payable{
        users[msg.sender].balance += msg.value;
    }

    function _deposit(address _addr, uint _n) public {
        users[_addr].balance += _n;
    }

    function withdraw(uint _n) public{
        require(users[msg.sender].balance >= _n);
        users[msg.sender].balance -= _n;
        payable(msg.sender).transfer(_n);
    }

    function transfer1(address payable _to, uint _n) public {
        //조건
        require(Bank(_to).getUser(msg.sender).addr != address(0));
        users[msg.sender].balance-=_n;
        payable(_to).transfer(_n);

        //잔액 변경
        Bank(_to)._deposit(msg.sender,_n);
    }

    function transfer2(address payable _bank, address _user, uint _n) public {
        require(Bank(_bank).getUser(_user).addr != address(0));
        users[msg.sender].balance-=_n;
        payable(_bank).transfer(_n);
        Bank(_bank)._deposit(_user, _n);
    }

    function setTime(address _addr, uint _n) public {
        users[_addr].paid = _n;
    }
}


