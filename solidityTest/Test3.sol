// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Test3{
    /* 
    여러분은 검색 엔진 사이트에서 근무하고 있습니다. 고객들의 ID와 비밀번호를 안전하게 관리할 의무가 있습니다. 
    따라서 비밀번호를 rawdata(있는 그대로) 형태로 관리하면 안됩니다. 
    비밀번호를 안전하게 관리하고 로그인을 정확하게 할 수 있는 기능을 구현하세요.

    아이디와 비밀번호는 서로 쌍으로 관리됩니다. 
    비밀번호는 rawdata가 아닌 암호화 데이터로 관리되어야 합니다.
    (string => bytes32)인 mapping으로 관리

    value인 bytes32는 ID와 PW를 같이 넣은 후 나온 결과값으로 설정하기
    abi.encodePacked() 사용하기

    * 로그인 기능 - ID, PW를 넣으면 로그인 여부를 알려주는 기능
    * 회원가입 기능 - 새롭게 회원가입할 수 있는 기능
    ---------------------------------------------------------------------------
    * 회원가입시 이미 존재한 아이디 체크 여부 기능 - 이미 있는 아이디라면 회원가입 중지
    * 비밀번호 5회 이상 오류시 경고 메세지 기능 - 비밀번호 시도 회수가 5회되면 경고 메세지 반환
    * 회원탈퇴 기능 - 회원이 자신의 ID와 PW를 넣고 회원탈퇴 기능을 실행하면 관련 정보 삭제
    */
    mapping (string => bytes32) users;
    mapping (string => uint) signInCnt;

    function signIn(string memory _id, string memory _pw) public returns(bool){
        /*
        로그인 기능 - ID, PW를 넣으면 로그인 여부를 알려주는 기능
        비밀번호 5회 이상 오류시 경고 메세지 기능 - 비밀번호 시도 회수가 5회되면 경고 메세지 반환
        */
        if(checkPw(_id,_pw)) {
            signInCnt[_id]=0;
            return true;
        }
        else {
            signInCnt[_id]++;
            if(signInCnt[_id]==5) revert("You failed five times");
            return false;
        }
    }

    function signUp(string memory _id, string memory _pw) public {
        /*
        회원가입 기능 - 새롭게 회원가입할 수 있는 기능
        회원가입시 이미 존재한 아이디 체크 여부 기능 - 이미 있는 아이디라면 회원가입 중지
        */
        require(users[_id]==0x0,"Id is already exist");
        users[_id] = setPw(_id,_pw);
    }

    function withdrawal(string memory _id, string memory _pw) public {
        /*
        회원탈퇴 기능 - 회원이 자신의 ID와 PW를 넣고 회원탈퇴 기능을 실행하면 관련 정보 삭제
        */
        if(checkPw(_id,_pw)) delete users[_id];
        else revert("Check Id or Password");
    }

    function setPw(string memory _id, string memory _pw) internal pure returns(bytes32){
        return keccak256(abi.encodePacked(_id, _pw));
    }

    function checkPw(string memory _id, string memory _pw) internal view returns(bool){
        if(users[_id] == setPw(_id,_pw)) return true;
        return false;
    }

}