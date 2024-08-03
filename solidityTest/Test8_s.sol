// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Test8_s{
    /*
    안건을 올리고 이에 대한 찬성과 반대를 할 수 있는 기능을 구현하세요. 
    안건은 번호, 제목, 내용, 제안자(address) 그리고 찬성자 수와 반대자 수로 이루어져 있습니다.(구조체)
    안건들을 모아놓은 자료구조도 구현하세요. 

    사용자는 자신의 이름과 주소, 자신이 만든 안건 그리고 자신이 투표한 안건과 어떻게 투표했는지(찬/반)에 대한 정보[string => bool]로 이루어져 있습니다.(구조체)

    * 사용자 등록 기능 - 사용자를 등록하는 기능
    * 투표하는 기능 - 특정 안건에 대하여 투표하는 기능, 안건은 제목으로 검색, 이미 투표한 건에 대해서는 재투표 불가능
    * 안건 제안 기능 - 자신이 원하는 안건을 제안하는 기능
    * 제안한 안건 확인 기능 - 자신이 제안한 안건에 대한 현재 진행 상황 확인기능 - (번호, 제목, 내용, 찬반 반환 // 밑의 심화 문제 풀었다면 상태도 반환)
    * 전체 안건 확인 기능 - 제목으로 안건을 검색하면 번호, 제목, 내용, 제안자, 찬반 수 모두를 반환하는 기능
    -------------------------------------------------------------------------------------------------
    * 안건 진행 과정 - 투표 진행중, 통과, 기각 상태를 구별하여 알려주고 전체의 70%가 투표에 참여하고 투표자의 66% 이상이 찬성해야 통과로 변경, 둘 중 하나라도 만족못하면 기각
    */

    struct Prop{
        uint number;
        string title;
        string content;
        address proposer;
        uint pros;
        uint cons;
        Status result;
        uint blockNumber;
    }

    enum Status{
        ongoing,
        passed,
        failed
    }

    mapping(string => Prop) public proposals;
    uint propCount=1;

    struct User{
        string name;
        address addr;
        string[] proposals;
        mapping(string => bool) votes;
        mapping(string => bool) voted;
    }

    mapping(address => User) users;
    uint userCount;

    function signUp(string calldata _name) public {
        require(users[msg.sender].addr == address(0),"Nope");
        users[msg.sender].name = _name;
        users[msg.sender].addr=msg.sender;
        userCount++;
    }

    function propose(string calldata _title, string calldata _content) public {
        proposals[_title] = Prop(propCount++, _title, _content, msg.sender, 0,0, Status.ongoing, block.number);
        users[msg.sender].proposals.push(_title);
    }

    function vote(string calldata _title, bool _isPro) public {
        require(users[msg.sender].addr != address(0));
        require(users[msg.sender].voted[_title]==false);
        require(block.number <= proposals[_title].blockNumber+15 && proposals[_title].result == Status.ongoing);
        _isPro ? proposals[_title].pros++ : proposals[_title].cons++;
        users[msg.sender].votes[_title] = _isPro;
        users[msg.sender].voted[_title] = true;
    }

    //안건 진행 과정 - 투표 진행중, 통과, 기각 상태를 구별하여 알려주고 
    // 전체의 70%가 투표에 참여하고 투표자의 66% 이상이 찬성해야 통과로 변경, 둘 중 하나라도 만족못하면 기각
    function setResult(string calldata _title) public {
        //solidity 자체적으로 되는게 아니고 web3js가 불러줘야하는 종류의 함수
        //누군가 propose 하면 block number를 받아오고 밖에서 현재 block number+16이 되면 그 때 _title에 대해 setResult를 진행시켜라 라는 코드를 밖에서 짜야함
        require(proposals[_title].blockNumber+15<block.number);
        uint pros = proposals[_title].pros;
        uint cons = proposals[_title].cons;
        uint total = pros+cons;
        //나누기 쓰지마라
        if(total*100 >= userCount*70 && pros*100 >= total*66 ){
            proposals[_title].result = Status.passed;
        }
        else{
            proposals[_title].result = Status.failed;
        }
    }
    

    function getMyProposals() public view returns(Prop[] memory){
        string[] memory _proposals = users[msg.sender].proposals;
        Prop[] memory res = new Prop[](_proposals.length);

        for(uint i=0;i<_proposals.length;i++){
            res[i] = proposals[_proposals[i]];
        }

        return res;
    }

    function getProposal(string calldata _title) public view returns(Prop memory){
        return proposals[_title];
    }

    
}

contract Block {
    constructor() {
        blockNumber = block.number;
    }

    uint public blockNumber;

    function setBlockNumber() public {
        blockNumber = block.number;
    }

    function getBlockNumber() public view returns(uint){
        return block.number;
    }

    function getBlockHash(uint _n) public view returns(bytes32){
        return blockhash(_n);
    }
}