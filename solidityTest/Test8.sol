// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Test8{
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
    struct Vote{
        uint idx;
        string title;
        string content;
        address addr;
        uint aCnt;
        uint dCnt;
    }

    struct User{
        string name;
        address addr;
        Vote[] myVotes;
        mapping(string=>bool) otherVotes;
        mapping(string=>bool) votingStatus;
    }

    mapping(address=>User) users;
    mapping(string=>Vote) votes;
    uint voteIdx=1;
    uint userCnt;

    function signUp(string memory _name) public {
        /*
        사용자 등록 기능 - 사용자를 등록하는 기능
        */
        User storage temp = users[msg.sender];
        temp.name=_name;
        temp.addr=msg.sender;
        userCnt++;
    }

    function setVote(string memory _t, string memory _c) public{
        /*
        안건 제안 기능 - 자신이 원하는 안건을 제안하는 기능
        */
        /*
        uint idx;
        string title;
        string content;
        address addr;
        uint aCnt;
        uint dCnt;
        */
        require(bytes(votes[_t].title).length==0,"Nope");
        Vote memory temp = Vote({idx:voteIdx++, title:_t, content:_c,addr:msg.sender,aCnt:0,dCnt:0});
        votes[_t] = temp;
        users[msg.sender].myVotes.push(temp);
    }

    function vote(string memory _t, bool _v) public{
        /*
        * 투표하는 기능 - 특정 안건에 대하여 투표하는 기능, 안건은 제목으로 검색, 이미 투표한 건에 대해서는 재투표 불가능
        */
        require(votes[_t].addr!=msg.sender,"Nope");
        require(users[msg.sender].otherVotes[_t]==false, "Already vote");
        users[msg.sender].otherVotes[_t]=true;
        users[msg.sender].votingStatus[_t]=_v;

        if(_v==true){
            votes[_t].aCnt++;
        }
        else{
            votes[_t].dCnt++;
        }
    }

    function getMyVotes() public view returns(Vote[] memory){
        /*
        * 제안한 안건 확인 기능 - 자신이 제안한 안건에 대한 현재 진행 상황 확인기능 - (번호, 제목, 내용, 찬반 반환 // 밑의 심화 문제 풀었다면 상태도 반환)
        * 안건 진행 과정 - 투표 진행중, 통과, 기각 상태를 구별하여 알려주고 전체의 70%가 투표에 참여하고 투표자의 66% 이상이 찬성해야 통과로 변경, 둘 중 하나라도 만족못하면 기각
        * 안건 진행 과정 - 투표 진행중, 통과, 기각 상태를 구별하여 알려주고 15개 블록 후에 전체의 70%가 투표에 참여하고 투표자의 66% 이상이 찬성해야 통과로 변경, 둘 중 하나라도 만족못하면 기각
        */
        //aCnt + dCnt /usercnt *100 >=70 이고, aCnt / aCnt+dCnt * 100>=66 이면 통과, 아니면 기각
        Vote[] memory temp = users[msg.sender].myVotes;


        for(uint i=0;i<temp.length;i++){
            Vote memory v = temp[i];
            string memory _s="InProgress";
            if((v.aCnt+v.dCnt)/userCnt*100>=70){
                if(v.aCnt / (v.aCnt+v.dCnt) * 100>=66) _s="Passed";
                else _s="Rejected";
            }
        }
        return users[msg.sender].myVotes;
    }
    
    function getAllVotes(string memory _t) public view returns(Vote memory){
        /*
        * 전체 안건 확인 기능 - 제목으로 안건을 검색하면 번호, 제목, 내용, 제안자, 찬반 수 모두를 반환하는 기능
        */
        return votes[_t];
    }
}